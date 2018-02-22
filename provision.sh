#!/bin/bash
set +e

function _run {
    local msg=$1
    shift
    if [ -z "$DEBUG" ]; then
        echo -n "$msg..."
        $@ 2>&1 >/dev/null
    else
        echo "$msg..."
        $@
    fi
    echo "done."
}

function _recipe {
    source ${HOME}/dotfiles/recipes/$1
}

USER=${USER:-$(whoami)}
_PLATFORM=$(uname -s | awk '{print tolower($1)}')

for recipe in base $@; do
    _recipe $recipe
done

echo "Finished, restarting shell."
exec $SHELL
