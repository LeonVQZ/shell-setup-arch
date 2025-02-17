#!/bin/bash

# Install Fish, Vim, Tmux

install_arch_packages() {
  echo "[+] Installing Arch packages"
  sudo pacman -Syu fish vim tmux terminator cmake gcc pkgconfig fontconfig libxft freetype2 unzip
}

install_rust() {
	echo "[+] Installing Rust"
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	echo 'set -x PATH $PATH ~/.cargo/bin'
	export PATH=$PATH:~/.cargo/bin
}

install_alacritty() {
	if [ ! -d ~/.cargo ]; then
		echo "[!] Rust not found! Installing..."
		install_rust
	fi
	echo "[+] Installing Alacritty"
	cargo install alacritty
	echo "[+] Copying Desktop File"
	sudo cp ./Alacritty/Alacritty.desktop /usr/share/applications/
	echo "[+] Copying icon"
	sudo cp ./Alacritty/Alacritty.svg /usr/share/icons/hicolor/scalable/apps/
	echo "[+] Copying Config"
	mkdir ~/.config/alacritty
	cp ./Alacritty/*.toml ~/.config/alacritty/
	cp ./Alacritty/*.yml ~/.config/alacritty/
}

install_nerdfont() {
	echo "[+] Installing NerdFont"
	wget -O /tmp/scp.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/SourceCodePro.zip
	unzip /tmp/scp.zip -d /tmp/scp '*.ttf'
	sudo mkdir /usr/share/fonts/saucecode-pro
	sudo mv /tmp/scp/*.ttf /usr/share/fonts/saucecode-pro
	rm -rf /tmp/scp
	sudo fc-cache -s -f
}

install_starship() {
	echo "[+] Installing Starship"
	curl -sS https://starship.rs/install.sh | sh
}

configure_fish() {
	mkdir ~/.config/fish
	cp ./Fish/* ~/.config/fish
}

configure_starship() {
	echo "[+] Configuring Starship"
	cp ./Starship/starship.toml ~/.config/starship.toml
}

configure_vim() {
	echo "[+] Configuring Vim"
	echo "[+] Installing Vim-Plug"
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	echo "[+] Copying .vimrc"
	cp ./Vim/.vimrc ~/.vimrc
	echo "[+] Remember to run :PlugInstall to install plugins!"
}

configure_tmux() {
	echo "[+] Configuring TMux"
	echo "[+] Installing TPM"
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	echo "[+] Installing Tmux Conf"
	cp ./Tmux/.tmux.conf ~/.tmux.conf
	echo "[+] Remember to press C-A+I to install!"
}

configure_terminator() {
	echo "[+] Configuring Terminator"
	mkdir ~/.config/terminator
	cp ./Terminator/config ~/.config/terminator/
}

install_neovim() {
	# Optional Install NeoVim
	echo "[?] Install Neovim? [Y/n]"
	read neovim_confirm
	if [[ $neovim_confirm == "" ]] || [[ $neovim_confirm == "Y" ]] || [[ $neovim_confirm == "y" ]]; then
		echo "[+] Installing Neovim"
		wget -O /tmp/nvim.tar.gz 'https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz'
		cd /tmp
		tar zxvf nvim.tar.gz
		sudo cp -R nvim-linux64/* /usr/local/
		rm -rf nvim*
		cd -
		echo "[+] Installing Neovim config"
		git clone https://github.com/mttaggart/neovim-config ~/.config/nvim
		echo "[+] Setting Fish aliases"
		echo "alias nv=nvim" >>~/.config/fish/config.fish
		echo "[+] Installing npm and nodejs for plugins tsserver, jsonls and pyright"
		sudo pacman -Syu nodejs npm
	fi
}

install_arch_packages
install_alacritty
install_starship
install_nerdfont
configure_fish
configure_starship
configure_vim
configure_tmux
configure_terminator
install_neovim


echo "[+] For vim remember to run :PlugInstall to install plugins!"
echo "[+] For tmux remember to press C-A+I to install plugins!"