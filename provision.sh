#!/bin/bash
set +e
trap 'exit' INT

RECIPE_PATH=${HOME}/dotfiles/recipes
RECIPES=$(ls $RECIPE_PATH|grep -v '^_' | sort)
INSTALL=()
STACK=()

if test -t 1; then
    ncolors=$(tput colors)
    if test -n "$ncolors" && test $ncolors -ge 8; then
        bold="$(tput bold)"
        dim="$(tput dim)"
        normal="$(tput sgr0)"
        red="$(tput setaf 1)"
        green="$(tput setaf 2)"
    fi
fi

while [[ $# -gt 0 ]]; do
    case $1 in
        -D|--debug)
            DEBUG=1
            shift
            ;;
        -l|--list)
            echo Available recipes:
            for recipe in $RECIPES; do
                description=$(grep '^# Description: ' "${RECIPE_PATH}/$recipe" \
                                  | cut -d' ' -f 3-)
                printf "%15s   %s\n" "$recipe" "$description"
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
        -h|--help)
            cat <<EOF
Usage: $(basename $0) [OPTION]... [RECIPE]...

Provision one or more dotfiles RECIPEs

Options:
  -A, --all         Install all available recipes.
  -D, --debug       Enable debug logging, including command output for each
                    step.
  -h, --help        Display this help text and exit.
  -l, --list        Display all available recipes and exit.
  -r, --restart     Restart the shell upon completion.

If no RECIPE is provided (and the -A/--all flag is not set), the
'base' recipe will be provisioned.

EOF
            exit
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
        "$@" >/dev/null 2>&1
    else
        echo "$msg..."
        "$@"
    fi
    echo "${green}done.${normal}"
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
        echo "${bold}${red}Could not load recipe '$1'${normal}" >&2
        exit 1
    fi
    STACK+=("$1")
    pushd "$path" >/dev/null
    echo "${dim}-- Recipe [${STACK[@]}]'${normal}"
    source "./${recipe}"
    popd >/dev/null
    unset 'STACK[${#STACK[@]}-1]'
    echo "${dim}-- Recipe [${STACK[@]}]${normal}"

}

USER=${USER:-$(whoami)}
_PLATFORM=$(uname -s | awk '{print tolower($1)}')

if [ "${#INSTALL[@]}" -eq 0 ]; then
    INSTALL=(base)
fi

for recipe in "${INSTALL[@]}"; do
    _recipe $recipe
done

echo "${green}Finished${normal}"
if [ -n "$RESTART_SHELL" ]; then
    echo "Restarting shell."
    exec $SHELL
fi
