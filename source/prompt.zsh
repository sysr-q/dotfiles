autoload colors && colors
for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN BLACK WHITE; do
	eval $COLOR='%{$fg_no_bold[${(L)COLOR}]%}'
	eval BOLD_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done
eval RESET='$reset_color'

function precmd {
	# Set the title to: user@host: ~/cur/dir
	print -Pn "\e]0;%n@%m: %~\a"
	PROMPT=$(make_prompt)
	RPROMPT="$(virtualenv_info) %*"
}

function prompt_char {
	git branch >/dev/null 2>/dev/null && print '±' && return
	# if svn branch: '§' (no idea how2svn)
	if [[ $(whoami) == "root" ]]; then
		print '#';
	else
		print '%%';
	fi
}

function virtualenv_info {
	[ $VIRTUAL_ENV ] && echo "%{${RESET}%}(%{${BLUE}%}$(basename $VIRTUAL_ENV)%{${RESET}%})"
}

function git_prompt_info {
	[ $(current_branch) ] || return
	pc="${GREEN}"; git_is_dirty || pc="${MAGENTA}"
	echo "%{${RESET}%}%{${pc}%}$(current_branch)%{${RESET}%}"
}

function make_prompt {
	# <user> at <host>
	p="%{${NCOLOR}%}%n%{${RESET}%} at %{${YELLOW}%}%m%{${RESET}%}"
	# in <dir>
	p="${p} in %{${CYAN}%}${PWD/#$HOME/~}%{${RESET}%}"
	# git prompt (if applicable)
	nc="$(git_prompt_info)"
	[ "${nc}" ] && p="${p} %{${RESET}%}on ${nc}"
	# newline + prompt
	p="${p}\n%{${YELLOW}%}$(prompt_char)%{${RESET}%} "
	echo $p
}

if [[ $(whoami) == "root" ]]; then
	NCOLOR=${RED};
else
	NCOLOR=${GREEN};
fi

