autoload colors && colors
for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN BLACK WHITE; do
	eval $COLOR='%{$fg_no_bold[${(L)COLOR}]%}'
	eval BOLD_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done
eval RESET='$reset_color'

function precmd {
	# Set the title to: user@host: ~/cur/dir
	print -Pn "\e]0;%n@%m: %~\a"
	PROMPT=$(make-prompt)
	RPROMPT="$(virtualenv-info) %*"
}

function prompt-char {
	git branch >/dev/null 2>/dev/null && print '±' && return
	# if svn branch: '§' (no idea how2svn)
	if [[ $(whoami) == "root" ]]; then
		print '#';
	else
		print '%%';
	fi
}

function virtualenv-info {
	[ $VIRTUAL_ENV ] && echo "%{${RESET}%}(%{${BLUE}%}$(basename $VIRTUAL_ENV)%{${RESET}%})"
}

function make-prompt {
	# <user> at <host>
	p="%{${NCOLOR}%}%n%{${RESET}%} at %{${YELLOW}%}%m%{${RESET}%}"
	# in <dir>
	p="${p} in %{${CYAN}%}${PWD/#$HOME/~}%{${RESET}%}"
	# git prompt (if applicable)
	nc="$(git-prompt-info)"
	[ "${nc}" ] && p="${p} %{${RESET}%}on ${nc}"
	# newline + prompt
	p="${p}\n%{${YELLOW}%}$(prompt-char)%{${RESET}%} "
	echo $p
}

if [[ $(whoami) == "root" ]]; then
	NCOLOR=${RED};
else
	NCOLOR=${GREEN};
fi
