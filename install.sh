#!/bin/bash
# My env install script ~ Skiqqy.

declare -A osInfo;
osInfo[/etc/redhat-release]=dnf
osInfo[/etc/arch-release]=pacman
osInfo[/etc/debian_version]=apt-get
osInfo[/etc/alpine-release]=apk

for f in "${!osInfo[@]}"
do
	if [[ -f $f ]];then
		echo Package manager: ${osInfo[$f]}
		if [[ ${osInfo[$f]} = "pacman" ]]; then
			## Arch/ Manjaro ##
			sudo pacamn -Syu
			sudo pacman -S vim tmux git make zsh yay
			yay
			yay -S powerline
		elif [[ ${osInfo[$f]} = "dnf" ]]; then
			## Fedora/ RedHat ##
			sudo dnf install vim tmux git make zsh powerline tmux-powerline acpi
		elif [[ ${osInfo[$f]} = "apt-get" ]]; then
			## Debian ##
			sudo apt update
			sudo apt install vim tmux git make zsh powerline
		elif [[ ${osInfo[$f]} = "apk"  ]]; then
			## Alpine-Linux
			sudo apk add vim tmux git make zsh # no powerline package
		fi
		echo "finished with ${osInfo[$f]}"
	fi
done

(
	# Clone repos
	dir="$HOME/repos"
	mkdir "$dir"
	git clone https://git.sr.ht/~skiqqy/.dotfiles "$dir/.dotfiles"
	git clone https://git.sr.ht/~skiqqy/.tmux     "$dir/.tmux"

	dir="$HOME/Builds"
	mkdir "$dir"
	git clone https://git.sr.ht/~skiqqy/dwm "$dir/dwm"
	git clone https://git.sr.ht/~skiqqy/st  "$dir/st"

	# Begin Builing
	make -C dwm/
	sudo make -C st/
	make -C "$HOME"/repos/.dotfiles
	cd "$HOME"/repos/.tmux || exit
	./install.sh
)
