# Part of the "sysrq dotfiles experience". Available at:
#    sysrq <chris@gibsonsec.org> https://github.com/sysr-q/dotfiles
#
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
#
# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# For more information, please refer to <http://unlicense.org>

# /etc/profile and ~/.profile here
if status --is-login
		## /etc/profile
		# Set our umask
		umask 022

		# Set our default path
        set -xg PATH /usr/local/sbin /usr/local/bin /usr/bin $PATH

		# Add gnu coreutils (from brew) for OS X.
		set -xg PATH /usr/local/opt/coreutils/libexec/gnubin $PATH

		# Unset these, copying /etc/profile
		set -e TERMCAP
		set -e MANPATH

		## ~/.profile
		set -xg GOPATH "$HOME/go"

		set -xg PATH $HOME/.bin $HOME/.local/bin $GOPATH/bin $PATH

		set -xg EDITOR vim
		set -xg BROWSER chromium

		# Fight me.
		# set -xg LANG en_US.UTF-8

		# TODO: /etc/profile.d/*.{,c}sh
end

# I know how to use fish thx tho.
set -e fish_greeting

# start X at login
#if status --is-login
#	if test -z "$DISPLAY" -a $XDG_VTNR -eq 1
#		exec startx -- -keeptty
#	end
#end

# Only set up if we're in interactive mode.
if not status --is-interactive
	exit 0
end

set DOTFILES $HOME/.dotfiles

## Aliases
function nvim-maybe
	if command -v nvim >/dev/null ^/dev/null
		nvim $argv
	else
		/usr/bin/vim $argv
	end
end

alias vi nvim-maybe
alias vim nvim-maybe

alias grep "grep --color=auto"
alias ls "ls --color=auto --group-directories-first"
alias ll "ls --color=auto -l"
alias rm "rm -I"

# Set up dircolors for ls, et al.
if test -f "$DOTFILES/config/dircolors.ansi-dark"
	eval (dircolors -c "$DOTFILES/config/dircolors.ansi-dark")
end

# Set up keychain.
set KEYS id_rsa id_ecdsa id_ed25519
if command -s keychain >/dev/null ^/dev/null
	set -l IFS
	eval (keychain --eval --agents ssh -Q --quiet $KEYS)
end
