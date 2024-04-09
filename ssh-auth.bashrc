# Enable SSH agent forwarding if no other agent is configured
if [ -z "$SSH_AUTH_SOCK" ]; then
	export SSH_AUTH_SOCK=/run/user/%UID%/ssh-auth-socket
fi
