declare -A osInfo;
osInfo[/etc/redhat-release]=dnf
osInfo[/etc/arch-release]=pacman
osInfo[/etc/debian_version]=apt-get
osInfo[/etc/alpine-release]=apk

for f in ${!osInfo[@]}
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

# Clone repos
mkdir $HOME/repos
cd $HOME/repos
git clone https://github.com/skiqqy/.dotfiles/
git clone https://github.com/skiqqy/.tmux
mkdir $HOME/Builds
cd $HOME/Builds

# Begin Builing
git clone https://github.com/skiqqy/dwm
git clone https://github.com/skiqqy/st
make -C dwm/
sudo make -C st/

make -C $HOME/repos/.dotfiles
cd $HOME/repos/.tmux
./install.sh
cd
