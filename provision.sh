#!/bin/bash
set +e

RECIPE_PATH=${HOME}/dotfiles/recipes
RECIPES=$(ls $RECIPE_PATH|grep -v '^_')
INSTALL=(base)

while [[ $# -gt 0 ]]; do
    case $1 in
        -D|--debug)
            DEBUG=1
            shift
            ;;
        -l|--list)
            echo Available recipes:
            for recipe in $RECIPES; do
                echo "  $recipe"
            done
            exit
            ;;
        -A|--all)
            INSTALL=($RECIPES)
            shift
            ;;
        *)
            INSTALL+=("$1")
            shift
    esac
done

INSTALL=($(for recipe in "${INSTALL[@]}"; do
               echo $recipe
           done |sort | uniq))

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

for recipe in "${INSTALL[@]}"; do
    _recipe $recipe
done

echo "Finished, restarting shell."
exec $SHELL
