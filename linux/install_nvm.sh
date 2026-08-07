#!/bin/sh
set -e

_main() {
    printf "\033[92m+%s+\n"        "-------------------------------------------"
    printf "|\033[0m%s\033[92m|\n" " NVM (Node Version Manager) install script "
    printf "|\033[0m%s\033[92m|\n" "               version 1.0.0               "
    printf "|\033[0m%s\033[92m|\n" "            tachylatus @ GitHub            "
    printf "+%s+\033[0m\n"         "-------------------------------------------"

    export NVM_DIR="$HOME/.local/opt/nvm" && (
        [ -e "$NVM_DIR/.git" ] || {
            _info Cloning https://github.com/nvm-sh/nvm.git ...
            git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
        }
        cd "$NVM_DIR"
        _info "Checking out latest tag ..."
        git fetch --tags origin
        git checkout "$(git describe --abbrev=0 --tags --match "v[0-9]*" "$(git rev-list --tags --max-count=1)")"
    )
    _info Installing nvm "symlink ..."
    mkdir -p "$HOME/.local/bin"
    ln -sf "$NVM_DIR/nvm.sh" "$HOME/.local/bin/nvm"
    _info "Use" "source nvm" "to load into the shell environment."
}

_info() {
    printf "\033[94m%s\033[0m %s" "$1" "$2"
    [ -n "$3" ] && printf " \033[94m%s\033[0m" "$3"
    printf "\n"
}

_main "$@"
