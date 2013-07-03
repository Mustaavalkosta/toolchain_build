#!/bin/bash

# Copyright (C) 2011 Linaro
#
# This file is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.

ARG_PREFIX_DIR=/home/mustaavalkosta/pizzabean/prebuilts/gcc/linux-x86/arm/android-toolchain-eabi-4.8
ARG_TOOLCHAIN_SRC_DIR=${PWD%/build}

ARG_WITH_SYSROOT=

abort() {
  echo $@
  exec false
}

error() {
  abort "[ERROR] $@"
}

warn() {
  echo "[WARNING] $@"
}

info() {
  echo "[INFO] $@"
}

note() {
  echo "[NOTE] $@"
}

PROGNAME=`basename $0`

usage() {
  echo "Usage: $PROGNAME [options]"
  echo
  echo "Valid options (defaults are in brackets)"
  echo "  --prefix=<path>             Specify installation path [/tmp/android-toolchain-eabi]"
  echo "  --with-sysroot=<path>       Specify SYSROOT directory"
  echo "  --help                      Print this help message"
  echo
}

while [ $# -gt 0 ]; do
  ARG=$1
  ARG_PARMS="$ARG_PARMS '$ARG'"
  shift
  case "$ARG" in
    --prefix=*)
      ARG_PREFIX_DIR="${ARG#*=}"
      ;;
    --toolchain-src=*)
      ARG_TOOLCHAIN_SRC_DIR="${ARG#*=}"
      ;;
    --with-gcc=*)
      ARG_WITH_GCC="${ARG#*=}"
      ;;
    --with-gdb=*)
      ARG_WITH_GDB="${ARG#*=}"
      ;;
    --with-sysroot=*)
      ARG_WITH_SYSROOT="${ARG#*=}"
      ;;
    --help)
      usage && abort
      ;;
    *)
      error "Unrecognized parameter $ARG"
      ;;
  esac
done

BUILD_ARCH=`uname -m`
BUILD_WITH_LOCAL=
BUILD_HOST=
BUILD_SYSROOT=

if [ ! -z "${ARG_WITH_SYSROOT}" ]; then
  if [ ! -d "${ARG_WITH_SYSROOT}" ]; then
    error "SYSROOT ${ARG_WITH_SYSROOT} not exist"
  fi
  BUILD_SYSROOT="--with-sysroot=${ARG_WITH_SYSROOT}"
fi

if echo "$BUILD_ARCH" | grep -q '64' ; then
  info "Use 64-bit Build environment"
  BUILD_HOST=x86_64-linux-gnu
  ABI="32"
  CFLAGS="-m32"
  CXXFLAGS="-m32"
  LDFLAGS="-L/usr/lib32"
  export ABI CFLAGS CXXFLAGS LDFLAGS
else
  info "Use 32-bit Build environment"
  BUILD_HOST=i686-unknown-linux-gnu
fi

[ -z "$TARGET" ] && TARGET=arm-linux-androideabi

${ARG_TOOLCHAIN_SRC_DIR}/build/configure \
  --prefix=/home/mustaavalkosta/pizzabean/prebuilts/gcc/linux-x86/arm/android-toolchain-eabi-4.8 \
  --target=${TARGET} \
  --disable-docs --disable-nls \
  --enable-graphite \
  --enable-gold=default \
  --host=${BUILD_HOST} --build=${BUILD_HOST} \
  ${BUILD_SYSROOT} \
  \
  --with-gcc-version=4.8 \
  --with-gdb-version=linaro-7.6-2013.05 \
  --with-binutils-version=2.23.2 \
  \
  --with-gmp-version=5.1.2 \
  --with-mpfr-version=3.1.2 \
  --with-mpc-version=1.0.1 \
  --with-cloog-version=0.18.0 \
  --with-ppl-version=1.0 \
  --disable-ppl-version-check \
  --disable-cloog-version-check \
  \
  ${LINARO_BUILD_EXTRA_CONFIGURE_FLAGS}

make HOSTGCC="$HOSTGCC" && make install

cat >${ARG_PREFIX_DIR}/BUILD-INFO.txt <<'EOF'
Files-Pattern: *
License-Type: open
EOF
