#!/bin/sh
set -e

_main() {
    printf "\033[92m+%s+\n"        "---------------------------------------"
    printf "|\033[0m%s\033[92m|\n" " Git Credential Manager install script "
    printf "|\033[0m%s\033[92m|\n" "             version 1.0.0             "
    printf "|\033[0m%s\033[92m|\n" "          tachylatus @ GitHub          "
    printf "+%s+\033[0m\n"         "---------------------------------------"

    REPO=git-ecosystem/git-credential-manager
    REPO_URL=https://github.com/$REPO
    _info "Target repository:" "$REPO_URL"

    if [ -n "$2" ]; then
        _error "ERROR: Too many arguments ($#)."
        exit 2
    fi
    if [ -n "$1" ]; then
        VERSION=${1#v}
        _info "Target version (manually specified):" "$VERSION"
    else
        _github_latest_release_tag "$REPO"
        VERSION=${TAG#v}
    fi

    FILENAME="gcm-linux_amd64.${VERSION:?No version specified}.deb"
    URL="$REPO_URL/releases/download/v${VERSION}/${FILENAME}"
    _info Downloading "$FILENAME" ...
    curl -#LO "$URL"
    _info Installing "$FILENAME" ...
    sudo dpkg -i "$FILENAME"
    rm -v "$FILENAME"
}

_error() {
    printf "\033[91m%s\033[0m\n" "$1"
}

_info() {
    printf "\033[94m%s\033[0m %s" "$1" "$2"
    [ -n "$3" ] && printf " \033[94m%s\033[0m" "$3"
    printf "\n"
}

_github_latest_release_tag() {
    REPO=${1:?} # owner/repo
    _info "Determine latest release tag of" "$REPO" "..."
    PATTERN="${2:-v[0-9]+\.[0-9]+\.[0-9]+}"
    TAG=$(curl -H "Accept: application/vnd.github+json" -s "https://api.github.com/repos/$REPO/tags" \
        | sed -E "s|^.*\"name\": \"($PATTERN)\".*$|\1|;t;d" \
        | sort -t. -k 1.2,1n -k 2,2n -k 3,3n \
        | tail -n 1)
    if [ -z "$TAG" ]; then
        _error "ERROR: Failed to detect latest release tag"
        return 1
    fi   
    _info "Latest release tag:" "$TAG"
    return 0
}

_main "$@"
