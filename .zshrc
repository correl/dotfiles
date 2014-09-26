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

    if [ ! -d $HOME/antigen ]; then
        git clone https://github.com/zsh-users/antigen.git $HOME/antigen
    fi

    source $HOME/antigen/antigen.zsh

    # Load the oh-my-zsh library
    antigen use oh-my-zsh

    # Bundles from the default repo (robbyrussel's oh-my-zsh)
    antigen-bundles <<EOF

git
git-extras
git-remote-branch
pip
ssh-agent

zsh-users/zsh-syntax-highlighting

EOF

    # Themes
    antigen-theme kphoen

    antigen-apply

    unsetopt correct_all
fi

export PATH=$HOME/bin:$PATH
export EDITOR="emacsclient"
export ALTERNATE_EDITOR=""

alias erl='rlwrap -a erl'

if which virtualenvwrapper.sh >/dev/null; then
    source virtualenvwrapper.sh
fi

# Emacs Cask
if [ ! -d ${HOME}/.cask ]; then
    curl -fsSkL https://raw.github.com/cask/cask.el/master/go | python
fi
export PATH="${HOME}/.cask/bin:$PATH"

if [ -d ${HOME}/.cabal/bin ]; then
    export PATH="${HOME}/.cabal/bin:$PATH"
fi
