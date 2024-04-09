#!/bin/sh
pipe=//./pipe/openssh-ssh-agent
pageant="/mnt/c/Users/hennor/.ssh/pageant.conf"
if [ -f "$pageant" ]; then
	pipe=$(cat "$pageant"|cut -d'"' -f2)
fi
exec /mnt/c/Users/hennor/go/bin/npiperelay.exe -ep -ei $pipe
