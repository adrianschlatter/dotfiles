# My personal dotfiles

This includes:

* zsh config
* tmux config
* nvim config
* askpass_ssh and askpass_sudo tools

To install, run:

```
mkdir -p ~/stow
cd ~/stow
git clone git@github.com:adrianschlatter/dotfiles.git
cd dotfiles
git submodule init
git submodule update
```

And then:

```
cd ~/stow
stow dotfiles
```


## zsh config

Provides

* powerlevel10k: A powerful prompt including status info on various things.
* zsh-syntax-highlighting: Syntax highlighting for zsh
    - and catppuccin: The theme to use for syntax highlighting

This config unfolds its full potential if you have installed:

* eza
* bat (better cat)
* neovim (the editor)
* rbw bitwarden cli (acces to your password vault)

```
sudo -A apt install eza
sudo -A apt install bat
sudo -A apt install neovim
sudo -A apt install cargo
cargo install --locked rbw
ln -s ~/.cargo/bin/rbw ~/.local/bin
ln -s ~/.cargo/bin/rbw-agent ~/.local/bin
```


## tmux.config

Install by running

```
# start a server but don't attach to it:
tmux start-server
# create a session but don't attach to it:
tmux new-session -d
# install plugins (same at <prefix>+I from inside tmux:
~/.config/tmux/plugins/tpm/scripts/install_plugins.sh
# enter tmux:
tmux
```

Make sure you download and install MesloGS NF font from
(here)[https://github.com/romkatv/powerlevel10k#fonts]. Then, tell your
terminal (xterm, iterm, whatever you have) to use this font.


## neovim config

* catppuccin theme
* treesitter for live-parsing and highlighting
* an LSP server for code completion
* telescope (fuzzy finder)
* harpoon (quicker navigation)
* debugging


### Installation

For copilot support, install node.js. Make sure its a new enough
version. When first starting nvim, run ```:Copilot setup```


## To Do

Write an installer script that

* removes .bash_history, .bash_logout, .bashrc, .profile
* removes pre-existing .zshrc, .zlogin, .zlogout
* stows this package (how are stow-things called?)
* let tmux install its plugins
* let nvim install packer plugins
* change the default shell


## History

* Configure treesitter, LSP, telescope, harpoon according to
  (ThePrimeagen)[https://youtu.be/w7i4amO_zaE?si=jhcGhrhTTjaMr4XR]
* Install nvim-dap (DAP client for nvim), nvim-dap-python (configures the
  python DAP adapter for nvim), nvim-dap-ui (nice GUI for debugging)
    - make sure to install debugpy (the DAP adapter for python) according to
      the GitHub site of nvim-dap-python
