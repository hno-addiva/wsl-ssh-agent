#!/bin/sh
pipe=//./pipe/openssh-ssh-agent
pageant="%USERPROFILE%/.ssh/pageant.conf"
if [ -f "$pageant" ]; then
	pipe=$(cat "$pageant"|cut -d'"' -f2)
fi
exec %NPIPERELAY% -ep -ei $pipe
