if [[ $TERM == "dumb" ]]; then # in emacs
    PS1='%(?..[%?])%!:%~%# '
    # for tramp to not hang, need the following. cf:
    # http://www.emacswiki.org/emacs/TrampMode
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    unfunction precmd
    unfunction preexec
else
    export LP_ENABLE_KUBECONTEXT=1

    if [ ! -d $HOME/.zgenom ]; then
        git clone https://github.com/jandamm/zgenom.git "${HOME}/.zgenom"
    fi
    source $HOME/.zgenom/zgenom.zsh
    zgenom autoupdate
    if ! zgenom saved; then
        zgenom ohmyzsh
        zgenom ohmyzsh plugins/git
        zgenom ohmyzsh plugins/git-extras
        zgenom ohmyzsh plugins/kubectl
        zgenom ohmyzsh plugins/kubectx
        zgenom ohmyzsh plugins/pip
        zgenom ohmyzsh plugins/pass
        zgenom ohmyzsh plugins/ssh-agent

        zgenom loadall <<EOF
zsh-users/zsh-syntax-highlighting
EOF
        zgenom save
        zgenom compile $HOME/.zshrc
    fi
    eval "$(starship init zsh)"
    unsetopt correct_all
fi

if [[ $TERM == "xterm-kitty" ]]; then
    # Enable ssh shell integrations for the Kitty terminal
    alias ssh="kitty +kitten ssh"
fi

export PATH=$HOME/bin:$PATH
export EDITOR="emacsclient"
export ALTERNATE_EDITOR=""

alias erl='rlwrap -a erl'

if [ -d ${HOME}/.cabal/bin ]; then
    export PATH="${HOME}/.cabal/bin:$PATH"
fi

export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# OPAM configuration
# . /home/correlr/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
# eval "$(pyenv init --path)"
# eval "$(pyenv virtualenv-init -)"
# pyenv global $(pyenv versions --bare --skip-aliases | egrep "^(\.?[[:digit:]]+)+$" | sort -rV) > /dev/null 2> /dev/null

export STACK_ROOT=/run/media/correlr/Correl/.stack
export PLATFORMIO_CORE_DIR=/run/media/correlr/Correl/.platformio

[ -f "/media/correlr/Correl/.ghcup/env" ] && source "/run/media/correlr/Correl/.ghcup/env" # ghcup-env
