FROM debian:bookworm-slim

# util-linux provides `setpriv`, which we use to drop privileges in deny mode.
# Unlike `gosu`, setpriv lets us explicitly set supplementary groups so that
# Docker-style --group-add behaviour works for hardware access configured via
# sandbox.container.group_add.
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    git \
    jq \
    neovim \
    iptables \
    util-linux \
    ripgrep \
    fd-find \
    ffmpeg \
    imagemagick \
    poppler-utils \
    pandoc \
    python3 \
    python3-pip \
    python3-venv \
    && ln -s /usr/bin/fdfind /usr/local/bin/fd \
    && rm -rf /var/lib/apt/lists/*

ENV VIRTUAL_ENV=/tmp/venv \
    PATH="/tmp/venv/bin:$PATH" \
    EDITOR=nvim

# Pre-fetch commonly needed python packages into the image. The runtime
# worktree is mounted later and the venv must be created as the sandbox user,
# so we keep a read-only wheelhouse instead of baking /tmp/venv into the image.
# project-startup.sh installs from this local wheelhouse, avoiding slow network
# downloads on every container start.
RUN python3 -m pip download --dest /opt/pip-wheels \
    'setuptools>=40.5.0' \
    setuptools-scm \
    wheel \
    flake8 \
    check-manifest \
    pytest \
    pytest-cov \
    tox \
    twine \
    numpy \
    scipy \
    matplotlib \
    pandas \
    openpyxl \
    statsmodels

# Workmux mounts the active worktree at runtime. Keep the image free of a
# second, potentially stale copy of the project; the venv is created in the
# container's writable layer when the sandbox starts.
WORKDIR /workspace

# Embed network init script (sets up iptables firewall, then drops privileges)
RUN cat <<'SCRIPT' > /usr/local/bin/network-init.sh
#!/bin/bash
set -euo pipefail

if [ -n "${WM_PROXY_HOST:-}" ] && [ -n "${WM_PROXY_PORT:-}" ]; then
    # Resolve hostnames to ALL IPs (multi-A records, round-robin DNS)
    PROXY_IPS=$(getent ahostsv4 "$WM_PROXY_HOST" | awk '{print $1}' | sort -u)
    RPC_HOST="${WM_RPC_HOST:-$WM_PROXY_HOST}"
    RPC_IPS=$(getent ahostsv4 "$RPC_HOST" | awk '{print $1}' | sort -u)

    if [ -z "$PROXY_IPS" ] || [ -z "$RPC_IPS" ]; then
        echo "network-init: failed to resolve proxy/RPC host" >&2
        exit 1
    fi

    # IPv4: default deny outbound
    iptables -P OUTPUT DROP
    iptables -A OUTPUT -o lo -j ACCEPT
    iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

    # Allow IPv4 DNS (UDP/TCP 53) to configured nameservers.
    # IPv6 egress is blocked below, so IPv6 nameservers cannot be used here.
    if [ -f /etc/resolv.conf ]; then
        grep '^nameserver' /etc/resolv.conf | awk '{print $2}' | while read -r ns; do
            case "$ns" in *:*) continue ;; esac
            iptables -A OUTPUT -d "$ns" -p udp --dport 53 -j ACCEPT
            iptables -A OUTPUT -d "$ns" -p tcp --dport 53 -j ACCEPT
        done
    fi

    # Allow ALL resolved proxy IPs (handles multi-A DNS)
    for ip in $PROXY_IPS; do
        iptables -A OUTPUT -d "$ip" -p tcp --dport "$WM_PROXY_PORT" -j ACCEPT
    done

    # Allow ALL resolved RPC IPs
    if [ -n "${WM_RPC_PORT:-}" ]; then
        for ip in $RPC_IPS; do
            iptables -A OUTPUT -d "$ip" -p tcp --dport "$WM_RPC_PORT" -j ACCEPT
        done
    fi

    # Reject (not drop) everything else to fail fast instead of hanging
    iptables -A OUTPUT -j REJECT

    # IPv6: block entirely to prevent leaks (fail closed)
    if ip6tables -L -n >/dev/null 2>&1; then
        ip6tables -P OUTPUT DROP
        ip6tables -A OUTPUT -o lo -j ACCEPT
        ip6tables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
        ip6tables -A OUTPUT -j REJECT
    else
        # If ip6tables unavailable, disable IPv6 via sysctl as fallback
        if ! sysctl -w net.ipv6.conf.all.disable_ipv6=1 2>/dev/null; then
            echo "network-init: failed to block IPv6 (neither ip6tables nor sysctl available)" >&2
            exit 1
        fi
    fi
fi

# Fix PTY ownership so the unprivileged user can read/write the terminal.
# Docker allocates the PTY as root; after the privilege drop, the user has no
# access to /dev/pts/0 unless we transfer ownership.
if [ -t 0 ]; then
    chown "${WM_TARGET_UID}:${WM_TARGET_GID}" "$(tty)"
fi

# Drop privileges via setpriv. Unlike gosu, setpriv lets us explicitly set
# supplementary groups via --groups, which is required so Docker-style
# --group-add behaviour works in deny mode (where the container starts as
# root and must drop privileges after iptables setup).
#
# WM_EXTRA_GIDS is a comma-separated list of group names or numeric GIDs
# configured via sandbox.container.group_add. We always prepend the primary
# GID so the supplementary group list matches Docker's default `--user`
# behaviour (primary GID present even with no extras), and so root's
# supplementary groups are never inherited by the dropped process.
#
# --inh-caps=-all drops inheritable capabilities; the setpriv man page warns
# that dropping UID/GID does not by itself reset capabilities.
#
# HOME=/tmp is preserved because downstream login shells may otherwise reset
# it to "/" (for UIDs not in /etc/passwd), breaking agents that look up their
# config dirs relative to HOME.
GROUPS_ARG="${WM_TARGET_GID}"
if [ -n "${WM_EXTRA_GIDS:-}" ]; then
    GROUPS_ARG="${GROUPS_ARG},${WM_EXTRA_GIDS}"
fi

exec setpriv \
    --reuid "${WM_TARGET_UID}" \
    --regid "${WM_TARGET_GID}" \
    --groups "${GROUPS_ARG}" \
    --inh-caps=-all \
    env HOME=/tmp "$@"
SCRIPT
RUN chmod +x /usr/local/bin/network-init.sh

# Install the project from the runtime-mounted worktree as the sandbox user.
RUN cat <<'SCRIPT' > /usr/local/bin/project-startup.sh
#!/bin/bash
set -euo pipefail

if [ ! -x "${VIRTUAL_ENV}/bin/python" ]; then
    python3 -m venv "${VIRTUAL_ENV}"
fi

# Activate the venv for the container command started by devcontainer/workmux.
# This exports VIRTUAL_ENV, prepends the venv bin directory to PATH, and keeps
# interactive shells in the activated environment from process start.
. "${VIRTUAL_ENV}/bin/activate"
exec "$@"
SCRIPT
RUN chmod +x /usr/local/bin/project-startup.sh

# Workmux invokes network-init.sh itself only in network-deny mode. Route both
# that path and normal (host-UID) mode through project-startup.sh so the venv
# and editable install are always created as the target user.
RUN cat <<'SCRIPT' > /usr/local/bin/sandbox-entrypoint.sh
#!/bin/sh
set -eu

if [ "${1:-}" = network-init.sh ]; then
    shift
    exec /usr/local/bin/network-init.sh /usr/local/bin/project-startup.sh "$@"
fi

exec /usr/local/bin/project-startup.sh "$@"
SCRIPT
RUN chmod +x /usr/local/bin/sandbox-entrypoint.sh

# Ensure host-exec shim directory is on PATH for login shells.
# Agents like Codex run commands via login shell (bash -lc) which sources
# /etc/profile, resetting PATH to system defaults and losing the shim
# directory that workmux prepends. This profile.d script re-adds it.
RUN cat <<'SCRIPT' > /etc/profile.d/workmux-shims.sh
# Re-activate the project venv for login shells. Agents like Codex run commands
# via login shell (bash -lc), which sources /etc/profile and may reset PATH.
if [ -f /tmp/venv/bin/activate ]; then
    . /tmp/venv/bin/activate
elif [ -d /tmp/venv/bin ]; then
    export VIRTUAL_ENV=/tmp/venv
    PATH="/tmp/venv/bin:$PATH"
fi
if [ -d /tmp/.workmux-shims/bin ]; then
    PATH="/tmp/.workmux-shims/bin:$PATH"
fi
export PATH
SCRIPT

ARG CACHE_BUST=1

# Install workmux (needed for sandbox RPC)
RUN curl -fsSL https://raw.githubusercontent.com/raine/workmux/main/scripts/install.sh | bash

# --- pi agent ---
# Install Node.js (required for pi coding agent CLI)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    rm -rf /var/lib/apt/lists/*

ARG CACHE_BUST=1

# Install pi coding agent CLI globally.
# npm global bin is /usr/local/bin so the `pi` binary is reachable when
# running as an arbitrary non-root UID (--user uid:gid).
RUN npm install -g @earendil-works/pi-coding-agent

ENTRYPOINT ["/usr/local/bin/sandbox-entrypoint.sh"]
