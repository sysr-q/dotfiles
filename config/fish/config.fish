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

# Only set up if we're in interactive mode.
if not status is-interactive
	exit 0
end

if status is-login
	umask 022

	set -e TERMCAP
	set -e MANPATH

	set -xg EDITOR vim
	set -xg BROWSER chromium
	set -xg GOPATH "$HOME/go"
	set -xg HOMEBREW_NO_ANALYTICS 1
	set -xg GPG_TTY (tty)

	# 'null' is invisible on Solarized Dark by default.
	set -x JQ_COLORS '1;39:0;39:0;39:0;39:0;32:1;39:1;39'

	## macOS specific stuff
	# Add gnu coreutils (from brew) for OS X.
	add_to_path /usr/local/opt/coreutils/libexec/gnubin
	# M1 Homebrew
	add_to_path /opt/homebrew/bin
	add_to_path /opt/homebrew/opt/coreutils/libexec/gnubin

	# python2/python3 pip (from brew)
	# We have them in this order so newer pip binaries are picked up.
	add_to_path ~/Library/Python/3.9/bin
	add_to_path ~/Library/Python/3.8/bin
	add_to_path ~/Library/Python/3.7/bin
	add_to_path ~/Library/Python/3.6/bin
	add_to_path ~/Library/Python/2.7/bin

	# General bin directories
	add_to_path ~/.bin ~/.local/bin

	# Language specific
	add_to_path $GOPATH/bin ~/.cargo/bin ~/.npm-packages/bin

	# Set our default path
	add_to_path /usr/local/sbin /usr/local/bin /usr/bin
end

set DOTFILES $HOME/.dotfiles

# Set up dircolors for ls, et al.
if test -f "$DOTFILES/config/dircolors.ansi-dark"
	eval (dircolors -c "$DOTFILES/config/dircolors.ansi-dark")
end

if command -q keychain
	set -l KEYS id_rsa id_ecdsa id_ed25519
	keychain --eval --agents ssh --quick --quiet $KEYS | source
end
