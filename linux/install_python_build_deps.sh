#!/bin/sh

# exit in case of errors (pipelines excluded)
set -e

# Python Developer's Guide - Setup and Building - Install dependencies:
#   https://devguide.python.org/getting-started/setup-building/index.html#install-dependencies

echo ">>> uncomment deb-src in /etc/apt/sources.list"
sudo sed -i 's/^# \(deb-src [^#]* main \)/\1/' /etc/apt/sources.list
grep "^deb-src" /etc/apt/sources.list

export DEBIAN_FRONTEND=noninteractive

echo ">>> apt-get update"
sudo apt-get update -y

echo ">>> apt-get build-dep"
sudo apt-get build-dep -y --no-install-recommends python3

echo ">>> apt-get install"
sudo apt-get install -y \
  build-essential gdb lcov pkg-config \
  libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev \
  libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev \
  lzma lzma-dev tk-dev uuid-dev zlib1g-dev
# Note that Debian 12 and Ubuntu 24.04 do not have the libmpdec-dev package.
# Python build will use a bundled version.
