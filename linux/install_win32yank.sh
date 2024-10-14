#!/bin/sh
set -e

_main() {
    printf "\033[92m+%s+\n"        "---------------------------"
    printf "|\033[0m%s\033[92m|\n" " Win32 Yank install script "
    printf "|\033[0m%s\033[92m|\n" "       version 1.0.0       "
    printf "|\033[0m%s\033[92m|\n" "    tachylatus @ GitHub    "
    printf "+%s+\033[0m\n"         "---------------------------"

    REPO=equalsraf/win32yank
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
        current_version=$(git-credential-manager --version)
        if [ "$VERSION" = "${current_version%%+*}" ]; then
            _info "Already installed:" "$current_version"
            exit 0
        fi
    fi

    ARCH="x64"
    FILENAME="win32yank-${ARCH}.zip"
    URL="$REPO_URL/releases/download/v${VERSION:?No version specified}/${FILENAME}"
    TARGET_DIR="${HOME}/.local/opt/win32yank-v${VERSION}/bin"
    TARGET_LINK_DIR="${HOME}/.local/bin"
    TARGET_BIN="win32yank.exe"
    _info "Downloading, extracting and installing" "$TARGET_BIN" ...
    mkdir -p "${TARGET_DIR}" || exit 1
    curl -#L "$URL" | busybox unzip -oq - "${TARGET_BIN}" -d "${TARGET_DIR}" || exit 1
    chmod 755 "${TARGET_DIR}/${TARGET_BIN}" || exit 1
    _info "Installing link in" "$TARGET_LINK_DIR"  ...
    mkdir -p "${TARGET_LINK_DIR}" || exit 1
    ln -fs "${TARGET_DIR}/${TARGET_BIN}" "${TARGET_LINK_DIR}/${TARGET_BIN}"
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
