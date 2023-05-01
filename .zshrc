if [[ $TERM == "dumb" ]]; then	# in emacs
    PS1='%(?..[%?])%!:%~%# '
    # for tramp to not hang, need the following. cf:
    # http://www.emacswiki.org/emacs/TrampMode
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    unfunction precmd
    unfunction preexec
else
    if [ ! -d $HOME/.zgenom ]; then
        git clone https://github.com/jandamm/zgenom.git "${HOME}/.zgenom"
    fi
    source $HOME/.zgenom/zgenom.zsh
    zgenom autoupdate
    if ! zgenom saved; then
        zgenom ohmyzsh
        zgenom ohmyzsh plugins/git
        zgenom ohmyzsh plugins/git-extras
        zgenom ohmyzsh plugins/pip
        zgenom ohmyzsh plugins/pass
        zgenom ohmyzsh plugins/ssh-agent

        zgenom loadall <<EOF
nojhan/liquidprompt
zsh-users/zsh-syntax-highlighting
EOF
        zgenom save
        zgenom compile $HOME/.zshrc
    fi
    unsetopt correct_all
fi

export PATH=$HOME/bin:$PATH
export EDITOR="emacsclient"
export ALTERNATE_EDITOR=""

alias erl='rlwrap -a erl'

if [ -d ${HOME}/.cabal/bin ]; then
    export PATH="${HOME}/.cabal/bin:$PATH"
fi
