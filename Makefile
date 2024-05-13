
NPIPERELAY=$(shell which npiperelay.exe)
UID=$(shell id -u)
USERPROFILE_WIN=$(shell cd /mnt/c && cmd.exe /c echo %USERPROFILE%)
USERPROFILE=$(shell wslpath -au "$(USERPROFILE_WIN)")

all: activate

check-npipe:
	@if [ -z "$(NPIPERELAY)" ]; then \
		echo "ERROR: Could not find npiperelay.exe" ;\
		exit 1 ;\
	fi

install: check-npipe
	mkdir -p $(HOME)/.config/systemd/user
	sed -e "s/%UID%/$(UID)/" ssh-auth.socket > $(HOME)/.config/systemd/user/ssh-auth.socket
	sed -e "s!%NPIPERELAY%!$(NPIPERELAY)!" ssh-auth@.service > $(HOME)/.config/systemd/user/ssh-auth@.service
	mkdir -p $(HOME)/.local/sbin
	sed -e "s!%NPIPERELAY%!$(NPIPERELAY)!" -e "s!%USERPROFILE%!$(USERPROFILE)!" ssh-auth-relay.sh > $(HOME)/.local/sbin/ssh-auth-relay
	chmod +x $(HOME)/.local/sbin/ssh-auth-relay
	if ! grep -q ssh-auth-socket $(HOME)/.bashrc; then \
		sed -e "s/%UID%/$(UID)/" ssh-auth.bashrc >> $(HOME)/.bashrc; \
	fi

activate: install
	systemctl --user daemon-reload
	systemctl --user enable ssh-auth.socket
	@echo
	@echo "Start a new shell to set SSH_AUTH_SOCK to enable ssh-agent connection"
	@echo
