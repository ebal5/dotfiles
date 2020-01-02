export PATH := ${HOME}/bin:${HOME}/.local/bin:${PATH}
DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*)
EXCLUSIONS := .DS_Store .git .gitmodules .travis.yml .config
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))
BINFILES	 := $(wildcard bin/*)
CONFFILES	 := $(wildcard .config/*)


.PHONY: list
list: ## Show dot files in this repo
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)
	@$(foreach val, $(BINFILES), /bin/ls -dF $(val);)
	@$(foreach val, $(CONFFILES), /bin/ls -dF $(val);)

.PHONY: backup
backup:
	if [ ! -d $(HOME)/dotbackup ]; then mkdir -p $(HOME)/dotbackup; fi
	@$(foreach val, $(DOTFILES), if [ -e $(HOME)/$(val) ]; then mv $(HOME)/$(val) $(HOME)/dotbackup/; fi;)

.PHONY: copy
copy: $(DOTFILES) $(BINFILES)
	@$(foreach val, $(DOTFILES), /usr/bin/ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	if [ ! -d $(HOME)/bin ]; then \
		mkdir -p $(HOME)/bin ;\
	fi
	@$(foreach val, $(BINFILES), /usr/bin/ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	if [ ! -d $(HOME)/.config ]; then \
		mkdir $(HOME)/.config ;\
	fi
	@$(foreach val, $(CONFFILES), /usr/bin/ln -sfnv $(abspath $(val)) $(HOME)/$(val);)

.PHONY: init
init:
	curl -fsSL https://get.docker.com/rootless | sh

.PHONY: archlinux_pre
archlinux_pre:
	sudo pacman -Syu --noconfirm ;\
  sudo pacman -S --noconfirm git ;\
	if [ ! -x /usr/bin/yay ]; then\
		cd /tmp;\
		git clone "https://aur.archlinux.org/yay.git" &&\
		cd yay &&\
		makepkg -si --noconfirm ;\
		rm -rf /tmp/yay ;\
  fi
	yay -Syyu --noconfirm
	yay -S --noconfirm python
	yay -S --noconfirm pandoc aria2 alsa-tools kakasi tldr zsh fish vim 
	yay -S --noconfirm bat \
            exfat-utils \
            fd \
            fzf \
            lsd \
            ripgrep \
            sd \
            unarchiver \
            usleep \
            usbutils \
            adobe-source-han-sans-jp-fonts adobe-source-han-serif-jp-fonts \
            otf-ipafont otf-ipaexfont \
						powerline-fonts \
            ttf-cica \
						tmux \
            xsv \
            xdg-user-dirs \
            jq yq


.PHONY: envs
envs:
	if [ ! -x /usr/bin/pip ]; then\
		curl -kL "https://bootstrap.pypa.io/get-pip.py" | sudo python ;\
		sudo pip install --upgrade pip ;\
	fi
	if [ ! -x /usr/bin/pip3 ]; then\
	 	curl -kL "https://bootstrap.pypa.io/get-pip.py" | sudo python3 ;\
		sudo pip install --upgrade pip3 ;\
	fi
	sudo pip install xkeysnail ;\
	pip3 install --user beautifulsoup ;\
	pip3 install --user autopep8 ;\
	pip3 install --user flake8 ;\
	pip3 install --user yapf ;\
	pip3 install --user pandas ;\
	which anyenv ;\
	if [ ! $$? = 0 ]; then\
		git clone "https://github.com/anyenv/anyenv" $(HOME)/.anyenv;\
		$(HOME)/.anyenv/bin/anyenv init;\
		$(HOME)/.anyenv/bin/anyenv install --force-init;\
		$(HOME)/.anyenv/bin/anyenv install pyenv;\
	fi

.PHONY: archlinux
archlinux: archlinux_pre envs copy

.PHONY: archlinux_opt
archlinux_opt: archlinux
	yay -S --noconfirm docker \
        emacs \
        evince \
        fcitx-configtool \
        fcitx-gtk2 \
        fcitx-gtk3 \
        fcitx-mozc \
        fcitx-ui-light \
        i3 \
        lightdm \
        pacman-contrib \
        parcellite \
        pavucontrol \
        pcloud-drive \
        picom \
        qalculate-gtk \
        rofi \
        sl \
        termite \
        vivaldi \
        vlc \
        volumeicon \
        xdg-user-dirs \
        xorg \
        xorg-apps \
        xorg-drivers \
        xsel \

.PHONY: test
test:
	docker build -f tools/Dockerfile.archlinux -t dotfiles_archlinux tools
	docker run -it --rm -v $(pwd):/home/test/.dotfiles dotfiles_archlinux
