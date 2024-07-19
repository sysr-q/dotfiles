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

function __git_dir
	if not command -s git >/dev/null
		return 1
	end

	set -l repo_info (command git rev-parse --git-dir --is-inside-git-dir --is-bare-repository --is-inside-work-tree --short HEAD 2>/dev/null)
	echo "$repo_info"
end

function __git_is_ahead
	if not command -s git >/dev/null
		return 1
	end

	set -l ahead (command git rev-list '@{u}..' --count 2>/dev/null)
	echo "$ahead"
end

function fish_prompt
	if not set -q __fish_prompt_hostname
		set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
	end

	set -l SEP \uE0B0
	set -l SEPT \uE0B1
	set -l CUR_PWD (prompt_pwd)

	# user@host >
	if set -q __prompt_context
		echo -ns (set_color -b cyan) (set_color black) " @$__fish_prompt_hostname "
	else
		echo -ns (set_color -b cyan) (set_color black) " $USER@$__fish_prompt_hostname "
	end

	echo -ns (set_color -b blue) (set_color cyan) "$SEP"

	# ~/foo/bar >
	echo -ns (set_color -b blue) (set_color white) " $CUR_PWD "

	# > master >
	set -l bgc blue
	if test -n (__git_dir)
		set -l fgc blue
		set -l textc white
		# At some stage, test started caring about exit codes.
		git diff-files --quiet
		if test $status -ne 0;
			set bgc white
			set textc black
		else
			set bgc green
		end

		set -l ahead (__git_is_ahead)
		if test -n $ahead -a $ahead -ne 0
			set fgc white
			echo -ns (set_color -b $fgc) (set_color blue) "$SEP"
		end

		echo -ns (set_color -b $bgc) (set_color $fgc) "$SEP"
		echo -ns (set_color $textc) " " (__fish_git_prompt "%s") " "
	end

	if set -q __prompt_context
		echo -ns (set_color -b red) (set_color $bgc) "$SEP "
		echo -ns (set_color -b red) (set_color white) "$__prompt_context "
		echo -ns (set_color -b normal) (set_color red) "$SEP "
	else
		echo -ns (set_color -b normal) (set_color $bgc) "$SEP "
	end
end

function fish_right_prompt
	set -l last_status $status

	if test $last_status -gt 0
		echo -ns (set_color red) ":(" " " (set_color normal)
	end

	set_color normal
	date "+%H:%M:%S"
end
