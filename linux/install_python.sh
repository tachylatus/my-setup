#!/bin/sh
# Build dependencies need to be installed first (e.g. install-ubuntu/install_python_build_deps.sh)

# exit in case of errors (pipelines excluded)
set -e

printf "\033[92m+%s+\n"        "-----------------------------------"
printf "|\033[0m%s\033[92m|\n" " Build & Install Script for Python "
printf "|\033[0m%s\033[92m|\n" "           Version 1.0.0           "
printf "|\033[0m%s\033[92m|\n" "        tachylatus @ GitHub        "
printf "+%s+\033[0m\n"         "-----------------------------------"
echo

missing=""
for dep in curl gpg tar; do
    command -v "$dep" > /dev/null || missing="$missing $dep"
done
if [ -n "$missing" ]; then
    echo "Not found:$missing"
    printf "\033[91m%s\033[0m\n" "ERROR: One or more required utilies not found."
    exit 1
fi
[ "$(id -u)" -eq 0 ] && printf "\033[91m%s\033[0m\n" "Script should not be run as root" && exit 1

if [ -z "$1" ]; then
    printf %s "Python version (X.Y.Z | X.Y (latest patch release)): "
    read -r VERSION
else
    VERSION="$1"
fi
echo "$VERSION" | grep -Exq "([2-9]|[1-9][0-9]+)\.(0|[1-9][0-9]*)" && {
    echo "Determining latest $VERSION version ..."
    VERSION=$(echo "$VERSION" | tr . " ")
    VERSION=$(
    curl -#L https://www.python.org/ftp/python/ \
        | sed -E 's/<a href="[^"]+"/\n\0\n/g;t;d' \
        | sed -E 's/^<a href="(([2-9]|[1-9][0-9]+)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*))\/"/\1/;t;d' \
        | tr . " " | sort -k 1rn -k 2rn -k 3rn \
        | grep -m1 "^$VERSION " | tr " " .
    )
    [ -z "$VERSION" ] && {
        echo "ERROR: Latest version not found"
        exit 1
    }
    echo "    => $VERSION"
    if command -v "python${VERSION%.*}" > /dev/null; then
        :
    else
        printf "Press Enter to continue ..."
        read -r _ || exit 1
    fi
    echo
}
echo "$VERSION" | grep -Exq "([2-9]|[1-9][0-9]+)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)" || {
    echo "Invalid or unsupported VERSION"
    exit 1
}
short_version=${VERSION%.*}

if command -v "python$short_version" > /dev/null; then
    installed_version=$("python$short_version" -c \
        "import sys; print('.'.join(str(x) for x in sys.version_info[0:3]))")
    printf "Python %s already installed, will be replaced:\n    %s -> %s\n" \
        "$short_version" \
        "$installed_version" \
        "$VERSION"
    printf "Enter 'yes' to continue: "
    read -r answer || exit 1
    if [ "$answer" != "yes" ]; then
        echo "Ok, will not continue - aborted."
        exit 0
    fi
    echo
fi

PYTHON_VERSION=$VERSION
GPG_KEYS="$2"
TIMEOUT=1800

if [ -z "${2:-}" ]; then
    case "$PYTHON_VERSION" in
        # source: "OpenGPG Public Keys" on https://www.python.org/downloads/
        3.12.*|3.13.*) GPG_KEYS="A821E680E5FA6305";;
        3.10.*|3.11.*) GPG_KEYS="64E628F8D684696D";;
        3.8.*|3.9.*) GPG_KEYS="B26995E310250568";;
        3.6.*|3.7.*) GPG_KEYS="2D347EA6AA65421D FB9921286F5E1540";;
        *) echo "${2:?missing arg: GPG key (unknown for specified Python version)}"
    esac
else
    GPG_KEYS="$2"
fi

URL="https://www.python.org/ftp/python/${PYTHON_VERSION:?}/Python-$PYTHON_VERSION.tar.xz"

command -v gpg || { echo >&2 ">>> [ERROR] gpg not found"; exit 1; }

echo ">>> download"
echo "$URL"
echo "$URL.asc"
if command -v curl > /dev/null; then
    curl -#Lo python.tar.xz "$URL"
    curl -#Lo python.tar.xz.asc "$URL.asc"
elif command -v wget > /dev/null; then
    wget -O python.tar.xz "$URL"
    wget -O python.tar.xz.asc "$URL.asc"
else
    echo >&2 ">>> [ERROR] neither curl nor wget found"
    exit 1
fi

echo ">>> gpg: GNUPGHOME"
GNUPGHOME=".gnupg"; export GNUPGHOME;
#GNUPGHOME="$(mktemp -d)"; export GNUPGHOME;
#trap 'rm -rf "$GNUPGHOME"' EXIT

for GPG_KEY in $GPG_KEYS; do
    echo ">>> gpg: download GPG_KEY: $GPG_KEY"
    gpg --batch --recv-keys "$GPG_KEY"
done

echo ">>> gpg: verify archive"
gpg --batch --verify python.tar.xz.asc python.tar.xz

echo ">>> gpg: clean up"
#gpgconf --kill all
#rm -rf "$GNUPGHOME" python.tar.xz.asc
rm python.tar.xz.asc

echo ">>> extract archive"
tar -xf python.tar.xz
rm python.tar.xz
pwd
cd "./Python-$PYTHON_VERSION"
pwd

echo ">>> build: configure"
# some third-party extensions may require the interpreter to be dynamically linked (i.e. shared libraries)
./configure \
    --enable-optimizations \
    --with-lto \
    --enable-shared \
    --enable-loadable-sqlite-extensions \
    ;

echo ">>> build: make"
timeout -vk 60 $TIMEOUT make -j"$(nproc)" profile-opt

echo ">>> build: sudo make install"
#timeout -vk 60 $TIMEOUT make -j"$(nproc)" install
sudo timeout -vk 60 $TIMEOUT make -j"$(nproc)" altinstall

echo ">>> configuring dynamic linker/loader"
echo "/usr/local/lib" | sudo tee /etc/ld.so.conf.d/usr_local.conf
sudo ldconfig
