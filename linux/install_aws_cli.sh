#!/bin/sh
set -e

_main() {
    printf "\033[92m+%s+\n"        "---------------------------"
    printf "|\033[0m%s\033[92m|\n" " AWS CLI v2 install script "
    printf "|\033[0m%s\033[92m|\n" "       version 1.0.0       "
    printf "|\033[0m%s\033[92m|\n" "    tachylatus @ GitHub    "
    printf "+%s+\033[0m\n"         "---------------------------"

    REPO=aws/aws-cli
    SOURCE_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"

    if [ -n "$2" ]; then
        _error "ERROR: Too many arguments ($#)."
        exit 2
    fi
    if [ -n "$1" ]; then
        VERSION=${1#v}
        _info "Target version (manually specified):" "$VERSION"
        SOURCE_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${VERSION}.zip"
    else
        _github_latest_release_tag "$REPO"
        VERSION=${TAG#v}
        full_version=$(aws --version 2>/dev/null || true)
        current_version=${full_version#*/}
        current_version=${current_version%% *}
        if [ "$VERSION" = "$current_version" ]; then
            _info "Already installed:" "$full_version"
            exit 0
        fi
    fi
    _info "Source URL:" "$SOURCE_URL"

    TMP_DIR=./awscli_temp
    TARGET_DIR="${HOME}/.local/opt/awscli"
    TARGET_BIN_DIR="${HOME}/.local/bin"
    [ -e "$TMP_DIR" ] && { _info Deleting "$TMP_DIR" ... && rm -rf "$TMP_DIR" || exit 1; }
    _info Creating "$TMP_DIR" ...
    mkdir -p "$TMP_DIR"
    _info "Downloading and extracting" awscliv2.zip ...
    curl -#Lo awscliv2.zip "$SOURCE_URL" || exit 1
    busybox unzip -q awscliv2.zip -d "$TMP_DIR" || exit 1
    chmod 755 "${TMP_DIR}/aws/install" || exit 1
    _info "Running installer ..."
    "${TMP_DIR}/aws/install" --update --install-dir "${TARGET_DIR}" --bin-dir "${TARGET_BIN_DIR}" || exit 1
    _info "Cleaning up ..."
    rm awscliv2.zip
    rm -rf "$TMP_DIR" || exit 1
    _info "Testing ..."
    aws --version || exit 1
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
    PATTERN="${2:-[0-9]+\.[0-9]+\.[0-9]+}"
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
