# My personal dotfiles

This includes:

* zsh config
* tmux config
* nvim config
* askpass_ssh and askpass_sudo tools

## zsh config

Provides

* powerlevel10k: A powerful prompt including status info on various things.
* zsh-syntax-highlighting: Syntax highlighting for zsh
    - and catppuccin: The theme to use for syntax highlighting

This config unfolds its full potential if you have installed:

* exa (better ls, better tree)
* bat (better cat)
* rbw bitwarden cli (acces to your password vault)
* ssh-agent (ssh-keys added using passphrases from bitwarden)
* nvim (the editor)


## tmux.config

Install by running

```
tmux source-file ~/.config/tmux.conf
```

Make sure you download and install MesloGS NF font from
(here)[https://github.com/romkatv/powerlevel10k#fonts]. Then, tell your
terminal (xterm, iterm, whatever you have) to use this font.

Then, start tmux and install plugins by pressing prefix, I.


## neovim config

* catppuccin theme
* treesitter for live-parsing and highlighting
* an LSP server for code completion
* telescope (fuzzy finder)
* harpoon (quicker navigation)
* debugging


## Installation

For copilot support, install node.js. Make sure its a new enough
version. When first starting nvim, run ```:Copilot setup```


## History

* Configure treesitter, LSP, telescope, harpoon according to
  (ThePrimeagen)[https://youtu.be/w7i4amO_zaE?si=jhcGhrhTTjaMr4XR]
* Install nvim-dap (DAP client for nvim), nvim-dap-python (configures the
  python DAP adapter for nvim), nvim-dap-ui (nice GUI for debugging)
    - make sure to install debugpy (the DAP adapter for python) according to
      the GitHub site of nvim-dap-python
