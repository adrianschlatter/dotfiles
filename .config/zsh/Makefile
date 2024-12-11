.PHONY : all install clean

all:
	@echo "Clone powerlevel10k"
	@if [ ! -d ~/.config/zsh/powerlevel10k ]; then \
		git clone https://github.com/romkatv/powerlevel10k.git ~/.config/zsh/powerlevel10k; \
	fi
	@echo "Clone zsh-syntax-highlighting"
	@if [ ! -d ~/.config/zsh/zsh-syntax-highlighting ]; then \
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/zsh/zsh-syntax-highlighting; \
	fi
	@echo "Clone catppuccin"
	@if [ ! -d ~/.config/zsh/catppuccin ]; then \
		git clone https://github.com/catppuccin/zsh-syntax-highlighting.git ~/.config/zsh/catppuccin; \
	fi


install:
	@echo "Copy .zshrc"
# Check whether .zshrc exists:
	@if [ ! -L ~/.zshrc ]; then \
		cp ~/.config/zsh/dotzshrc ~/.zshrc; \
	else \
		@echo ".zshrc already exists"; \
		exit 1; \
	fi

	@echo "Link .zlogin"
# Check whether .zlogin exists:
	@if [ ! -L ~/.zlogin ]; then \
		ln -s .config/zsh/zlogin ~/.zlogin; \
	else \
		echo ".zlogin already exists"; \
		exit 1; \
	fi

	@echo "Link .zlogout"
# Check whether .zlogout exists:
	@if [ ! -L ~/.zlogout ]; then \
		ln -s .config/zsh/zlogout ~/.zlogout; \
	else \
		@echo ".zlogout already exists"; \
		exit 1; \
	fi

	@echo "If you need conda, run 'conda init zsh'"

clean:
	rm -rf ~/.config/zsh/powerlevel10k
	rm -rf ~/.config/zsh/zsh-syntax-highlighting
	rm -rf ~/.config/zsh/catppuccin
	rm -f ~/.zprofile
	rm -f ~/.zlogout
	@echo -n "Delete ~/.zshrc? [y/N] " && read ans && \
		if [ $${ans:-'N'} = 'y' ]; then rm -f ~/.zshrc; fi
