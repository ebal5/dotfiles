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
	if [ ! -d $(HOME)/dotbackup ]; then \
		mkdir -p $(HOME)/dotbackup/.config ;\
		mkdir -p $(HOME)/dotbackup/bin ;\
	fi
	@$(foreach val, $(DOTFILES), if [ -e $(HOME)/$(val) ]; then mv $(HOME)/$(val) $(HOME)/dotbackup/$(val); fi;)
	@$(foreach val, $(BINFILES), if [ -e $(HOME)/$(val) ]; then mv $(HOME)/$(val) $(HOME)/dotbackup/$(val); fi;)
	@$(foreach val, $(CONFFILES), if [ -e $(HOME)/$(val) ]; then mv $(HOME)/$(val) $(HOME)/dotbackup/$(val); fi;)

.PHONY: copy
copy: backup
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
	if [ ! -f $(HOME)/bin/docker ]; then \
		curl -fsSL "https://get.docker.com/rootless" | sh ;\
	fi
	curl -L https://raw.github.com/simonwhitaker/gibo/master/gibo -so ~/bin/gibo && \
		chmod +x ~/bin/gibo && \
		~/bin/gibo update ;\
	cd /tmp ;\
	git clone https://github.com/powerline/fonts.git --depth=1 ;\
	cd fonts ;\
	./install.sh ;\
	cd .. ;\
	rm -rf fonts ;\
	if [ ! -x /usr/bin/pip ]; then\
		curl -kL "https://bootstrap.pypa.io/get-pip.py" | sudo python ;\
		sudo pip install --upgrade pip ;\
	fi
	if [ ! -x /usr/bin/pip3 ]; then\
	 	curl -kL "https://bootstrap.pypa.io/get-pip.py" | sudo python3 ;\
		sudo pip install --upgrade pip3 ;\
	fi
	sudo pip install xkeysnail ;\
	pip3 install --user beautifulsoup4 ;\
	pip3 install --user autopep8 ;\
	pip3 install --user flake8 ;\
	pip3 install --user yapf ;\
	pip3 install --user pandas ;\
	if [ ! -d $(HOME)/.anyenv ]; then\
		git clone "https://github.com/anyenv/anyenv" $(HOME)/.anyenv;\
		$(HOME)/.anyenv/bin/anyenv init;\
		$(HOME)/.anyenv/bin/anyenv install --force-init;\
		$(HOME)/.anyenv/bin/anyenv install pyenv;\
		$(HOME)/.anyenv/bin/anyenv install plenv;
	fi
	zsh tools/zsh-initialize.zsh


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
	yay -Syyu --noconfirm ;\
	yay -S --noconfirm \
						alsa-tools \
						aria2 \
						bat \
						docker \
						fish \
						fzf \
						kakasi \
						lxc \
						pandoc \
						python \
						powerline-fonts \
						pacman-contrib \
						tldr \
						tmux \
						vim \
						yq \
						zsh \
            adobe-source-han-sans-jp-fonts adobe-source-han-serif-jp-fonts \
            exfat-utils \
            fd \
            jq \
            lsd \
						openssh \
            otf-ipafont otf-ipaexfont \
            ripgrep \
            sd \
            ttf-cica \
            unarchiver \
            usbutils \
            usleep \
            xdg-user-dirs \
            xsv
# Docker rootless
	echo kernel.unprivileged_userns_clone=1 | sudo tee -a /etc/sysctl.conf
	if pidof systemd; then sudo systemctl --system; fi
	$(eval USER := $(shell whoami))
	echo "$(USER):100000:65536" | sudo tee -a /etc/subuid
	echo "$(USER):100000:65536" | sudo tee -a /etc/subgid
	echo "lxc.net.0.type = empty" | sudo tee -a /etc/lxc/default.conf
	echo "lxc.idmap = u 0 100000 65536" | sudo tee -a /etc/lxc/default.conf
	echo "lxc.idmap = g 0 100000 65536" | sudo tee -a /etc/lxc/default.conf

.PHONY: archlinux
archlinux: archlinux_pre copy init ;

.PHONEY: optional
optional: init
# for xkeysnail
	$(eval USER := $(shell whoami))
	echo 'KERNEL=="uinput", GROUP="uinput"' | sudo tee -a /etc/udev/rules.d/40-udev-xkeysnail.rules
	sudo groupadd uinput
	sudo useradd -G input,uinput -s /sbin/nologin xkeysnail
	echo 'uinput' | sudo tee -a /etc/modules-load.d/uinput.conf
# for spacemacs
	git clone "https://github.com/syl20bnr/spacemacs" $(HOME)/.emacs.d

.PHONY: archlinux_opt
archlinux_opt: archlinux optional
	yay -S --noconfirm \
        evince \
        fcitx-im \
        fcitx-configtool \
        fcitx-mozc \
        fcitx-ui-light \
				feh \
        i3 \
        lightdm \
        lightdm-gtk-greeter \
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
        xsel

.PHONY: test
test:
	docker build -f tools/Dockerfile.archlinux -t dotfiles_archlinux tools ;\
	docker run -it --rm -v $(pwd):/home/test/.dotfiles dotfiles_archlinux ;\
