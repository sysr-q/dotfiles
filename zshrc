# Part of the "sysrq dotfiles experience". Available at:
#    sysrq <chris@gibsonsec.org> https://gitlab.com/sysrq/dotfiles
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

# Only set up if running interactively.
[[ -t 0 ]] || exit 0

DOTFILES=$HOME/.dotfiles

# TODO move this to zsh/aliases

# autocomplete stuff (very important!!!)
autoload -U compinit
compinit

# Source stuff from $DOTFILES/zsh. Like old ~/dotfiles/lib/source.sh
if [[ -d "$DOTFILES/zsh" ]]; then
	for file in $(find "$DOTFILES/zsh" -type f); do
		source "$file"
	done
fi

# I use these, but you can expand on it.
KEYS=(id_rsa id_ecdsa)

if command keychain >/dev/null 2>&1; then
	# Let's keychain it up in this fucker.
	eval $(keychain --eval --agents ssh -Q --quiet $KEYS)
fi

# vim: syntax=zsh
