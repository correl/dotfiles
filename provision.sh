#!/bin/bash
set +e
trap 'exit' INT

RECIPE_PATH=${HOME}/dotfiles/recipes
RECIPES=$(ls $RECIPE_PATH|grep -v '^_')
INSTALL=()
STACK=()

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
        -r|--restart)
            RESTART_SHELL=1
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
    local recipe
    local path
    if [ -f "$1" ]; then
        recipe="$(basename $1)"
        path=$(dirname "$1")
    elif [ -f "${RECIPE_PATH}/$1" ]; then
        recipe="$1"
        path="${RECIPE_PATH}"
    else
        echo "Could not load recipe '$1'" >&2
        exit 1
    fi
    STACK+=("$1")
    pushd "$path"
    echo "-- Recipe '${STACK[@]}' --"
    source "./${recipe}"
    echo "-- Recipe '${STACK[@]}' --"
    popd
}

USER=${USER:-$(whoami)}
_PLATFORM=$(uname -s | awk '{print tolower($1)}')

if [ -z "${INSTALL[@]}" ]; then
    INSTALL=(base)
fi


echo "-- Provisioning [${INSTALL[@]}] --"
for recipe in "${INSTALL[@]}"; do
    _recipe $recipe
done

echo "Finished"
if [ -n "$RESTART_SHELL" ]; then
    echo "Restarting shell."
    exec $SHELL
fi
