# Purpose

This configures a systemd based WSL instance such as Ubuntu to use the Windows SSH key agent service or any compatible SSH key agent running under Windows such as [Keepass](https://keepass.info/) [KeeAgent](https://lechnology.com/software/keeagent/).

# Requirements

Requires [npiperelay.exe](https://github.com/jstarks/npiperelay). Can be istalled manually, via wininstall or chocolatey

Requires a OpenSSH compatible SSH key agent running on Windows. Either ssh-agent from Windows OpenSSSH, Putty Pageant, Keepass kagent, or any other OpenSSH compatible key agent.

Note: Windows bundled ssh-agent prior to version 8.9 will fail if your WSL is using OpenSSL 8.9 or later. Upgrade your wWindows SSH to a later OpenSSH version using 'winget install "openssh beta"'. Use "ssh -V" from a cmd window to check your version. Or use another OpenSSH compatible Windows SSH Key agent.

# Installation

Install by running 'make'

# Uninstallation

Clean up .config/systemd/ and your .bashrc

# Theory of operation

There is four parts that makes this work

* [npiperelay.exe](https://github.com/jstarks/npiperelay) (windows side) enables connection to Windows pipes via WSL command pipes.
* [ssh-auth.socket](ssh-auth.socket) systemd socket creates a listening UNIX pipe on the WSL side
* [ssh-auth@.service](ssh-auth@.service) systemd service starts npiperelay.exe when an application (ssh or similar) connects to the UNIX pipe
* [ssh-auth.bashrc](ssh-auth.bashrc) sets SSH_AUTH_SOCK pointing to the above UNIX pipe, enabling ssh to find the ssh-agend connection

1. windows SSH key agent listens for local connections on //./pipe/openssh-ssh-agent
2. ssh connects to the listening socket set up by systemd  (/run/user/<uid>/ssh-auth-sock)
3. systemd starts npiperelay.exe, connecting to the WSL unix pipe socket to the Windows side pipe //./pipe/openssh-ssh-agent

# Related work

Inspired by the blog post [Use an ssh-agent in WSL with your ssh setup from windows 10](https://pscheit.medium.com/use-an-ssh-agent-in-wsl-with-your-ssh-setup-in-windows-10-41756755993e)

For WSL1 instances there is [wsl-ssh-agent](https://github.com/rupor-github/wsl-ssh-agent).

# Using Putty Pageant

[Putty](https://www.chiark.greenend.org.uk/~sgtatham/putty/) [pageant](https://the.earth.li/~sgtatham/putty/0.80/htmldoc/Chapter9.html#pageant) also supports OpenSSH clients, but it uses a session unique path for the pipe. You can use the --openssh option to have pageant write out a OpenSSH config file with the path, but further work is neded to integrate this in an seamless manner.

See pageant-relay.sh
