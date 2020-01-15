export SHELL=$(which zsh)

source ~/.zplug/init.zsh
zplug "sorin-ionescu/prezto"
zplug load --verbose

zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-completions"
zplug "modules/command-not-found", from:prezto
zplug "b4b4r07/enhancd", use:init.sh

if [[ ! -f "$HOME/.dotinstalled" ]]; then
    zplug install
    ln -s $HOME/.zplug/repos/sorin-ionescu/prezto $HOME/.zprezto
    setopt EXTENDED_GLOB
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
        ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done
    touch $HOME/.dotinstalled
fi

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
if which fzf > /dev/null ; then
	  fuzzy=fzf
	  if gibo help > /dev/null 2>&1; then
		    function genignore() {
			      gibo dump $(gibo list | fzf --multi | tr "\n" " ") >> .gitignore
		    }
	  fi
fi

dirfile=$(mktemp -p /tmp tmuxdir.XXXXX)
function __chpwd_savepath() {
    $(pwd > $dirfile)
}
function __exit_rmpath() {
    rm $dirfile
}
preexec() {
    local line=${1%%$'\n'}
    local cmd=${line%% *}
    if [ ${line} = 'exec ${SHELL}' -o $line = 'exec $SHELL' ] ; then
        if [ -f $dirfile ]; then
            rm $dirfile
        fi
    fi
}

alias -s txt="bat"
alias -s rb="ruby"
alias -s py="python"
function runcpp() {
    clang -O2 $1
    shift
    ./a.out $@
}
alias -s {c,cpp}="runcpp"
function runjava() {
    ccl=$1
    ccln=${ccl%.java}
    javac $ccl
    shift
    java $ccln $@
}
alias -s java="runjava"

[ -f $HOME/.config/shellrc ] && source $HOME/.config/shellrc
