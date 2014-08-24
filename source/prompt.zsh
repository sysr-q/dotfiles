autoload colors && colors
for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN BLACK WHITE; do
	eval $COLOR='%{$fg_no_bold[${(L)COLOR}]%}'
	eval BOLD_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
	eval ${COLOR}BG='%{$bg_no_bold[${(L)COLOR}]%}'
	eval BOLD_${COLOR}BG='%{$bg_bold[${(L)COLOR}]%}'
done
eval RESET='%{$reset_color%}'

function precmd {
	# Set the title to: user@host: ~/cur/dir
	print -Pn "\e]0;%n@%m: %~\a"
	PROMPT=$(make-prompt)
	RPROMPT="$(virtualenv-info) %*"
}

function prompt-char {
	git branch >/dev/null 2>&1 && print '±' && return
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
	SEP=$(echo -en '\uE0B0')
	SEPT=$(echo -en '\uE0B1')
	#echo "${BLUEBG}${BLUE} %m ${RESET}${BLUE}${separator}$RESET$(prompt-char) "
	PWD=$(pwd | sed -e "s#^$HOME#~#")
	# user@host >
	echo -n "${CYANBG}${BLACK} %n@%m ${RESET}${BLACKBG}${SEP}"
	# > ~/foo/bar >
	echo -n "${BLACKBG}${WHITE} ${PWD} "
	# > master >
	if [[ $(git-current-branch) != "" ]]; then
		BG="${GREENBG}"
		FG="${GREEN}"
		git-is-dirty || BG="${REDBG}"
		git-is-dirty || FG="${RED}"
		git-is-ahead || BG="${REDBG}"
		git-is-ahead || FG="${RED}"
		echo -n "${BG}${BLACK}${SEP}"
		echo -n "${BG}${WHITE} $(git-prompt-info) ${RESET}${FG}${SEP}${RESET} "
	else
		echo -n "${RESET}${BLACK}${SEP}${RESET} "
	fi
}

if [[ $(whoami) == "root" ]]; then
	NCOLOR=${RED};
else
	NCOLOR=${GREEN};
fi
