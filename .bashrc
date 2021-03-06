#
# ~/.bashrc
#

function set_bash(){
    # get current branch in git repo
    function parse_git_branch() {
	      BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
	      if [ ! "${BRANCH}" == "" ]
	      then
		        STAT=$(parse_git_dirty)
		        echo "[${BRANCH}${STAT}]"
	      else
		        echo ""
	      fi
    }

    # get current status of git repo
    function parse_git_dirty {
	      status=$(git status 2>&1 | tee)
	      dirty=$(echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?")
	      untracked=$(echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?")
	      ahead=$(echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?")
	      newfile=$(echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?")
	      renamed=$(echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?")
	      deleted=$(echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?")
	      bits=''
	      if [ "${renamed}" == "0" ]; then
		        bits=">${bits}"
	      fi
	      if [ "${ahead}" == "0" ]; then
		        bits="*${bits}"
	      fi
	      if [ "${newfile}" == "0" ]; then
		        bits="+${bits}"
	      fi
	      if [ "${untracked}" == "0" ]; then
		        bits="?${bits}"
	      fi
	      if [ "${deleted}" == "0" ]; then
		        bits="x${bits}"
	      fi
	      if [ "${dirty}" == "0" ]; then
		        bits="!${bits}"
	      fi
	      if [ ! "${bits}" == "" ]; then
		        echo " ${bits}"
	      else
		        echo ""
	      fi
    }

    export PS1="\u@\h:\W$(parse_git_branch)\n\$ "
    alias ls='ls --color=auto'

    [ -e $HOME/bin/ssh-agent.sh ] && source $HOME/bin/ssh-agent.sh
    if [ -f $HOME/.config/shellrc ]; then
        source $HOME/.config/shellrc
    fi
}


# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if which fish &> /dev/null; then
    exec fish
else
    set_bash
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/ebal/.sdkman"
[[ -s "/home/ebal/.sdkman/bin/sdkman-init.sh" ]] && source "/home/ebal/.sdkman/bin/sdkman-init.sh"
export CLASSPATH=$CLASSPATH:data/corenlp/*
