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
        current_version=$(git-credential-manager --version 2>/dev/null || true)
        if [ "$VERSION" = "${current_version%%+*}" ]; then
            _info "Already installed:" "$current_version"
            exit 0
        elif [ -n "$VERSION" ]; then
            _info "Currently installed:" "$current_version"
        fi
    fi

    DOWNLOAD_URL=$(_github_release_download_urls "$REPO" "$TAG" "gcm-linux.*(amd64|x64).*.deb")
    if [ "$(echo "$URL" | wc -l)" != 1 ]; then
        _error "ERROR: Received multiple download URLs matching given pattern"
        exit 1
    fi
    FILENAME=$(basename "$DOWNLOAD_URL")
    if [ -z "$FILENAME" ]; then
        _error "ERROR: Unable to determine filename from URL, $DOWNLOAD_URL"
        exit 1
    fi
    _info Downloading "$DOWNLOAD_URL" ...
    curl -#Lo "$FILENAME" "$DOWNLOAD_URL"
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

_github_release_download_urls() {
    REPO=${1:?} # owner/repo
    TAG=${2:?}
    PATTERN=${3:-'[^/"]*'}
    DOWNLOAD_URL=$(curl -H "Accept: application/vnd.github+json" -s "https://api.github.com/repos/$REPO/releases/tags/$TAG" \
        | sed -E 's#^\s*"browser_download_url":\s*"([^"]*/'"$PATTERN"')".*$#\1#;t;d' )
    echo "$DOWNLOAD_URL"
    return 0
}

_main "$@"
