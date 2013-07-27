#!/bin/bash
export TARGET_CFLAGS="$CFLAGS -O2 -march=armv7-a -mtune=cortex-a9"
export TARGET_CXXFLAGS="$CXXFLAGS -O2 -march=armv7-a -mtune=cortex-a9 -frtti"
PREFIX="/home/mustaavalkosta/pizzabean/prebuilts/gcc/linux-x86/arm"
GCC_VERSION_NUMBER="4.8"
GCC_VERSION="4.8"
BINUTILS_VERSION="2.23.2"
GMP_VERSION="5.1.2"
MPFR_VERSION="3.1.2"
MPC_VERSION="1.0.1"
GDB_VERSION="7.6"
CLOOG_VERSION="0.18.0"
PPL_VERSION="1.0"
ISL_VERSION="0.12.1"
SYSROOT="/"
[ -z "$SMP" ] && SMP="-j`getconf _NPROCESSORS_ONLN`"

if [ "$1" = "eabi" ]; then
    # arm-eabi
    mkdir -p $PREFIX/arm-eabi-$GCC_VERSION_NUMBER
    rm -rf $PREFIX/arm-eabi-$GCC_VERSION_NUMBER/*
    ./configure \
        --prefix="$PREFIX/arm-eabi-$GCC_VERSION_NUMBER" \
        --with-binutils-version="$BINUTILS_VERSION" \
        --with-cloog-version="$CLOOG_VERSION" \
        --with-gcc-version="$GCC_VERSION" \
        --with-gdb-version="$GDB_VERSION" \
        --with-gmp-version="$GMP_VERSION" \
        --with-gold-version="$BINUTILS_VERSION" \
        --with-mpfr-version="$MPFR_VERSION" \
        --with-mpc-version="$MPC_VERSION" \
        --with-ppl-version="$PPL_VERSION" \
        --with-isl-version="$ISL_VERSION" \
        --with-tune=cortex-a9 \
        --target=arm-eabi \
        --enable-graphite=yes \
        --enable-gold=yes \
        --disable-docs

    make $SMP && make install

elif [ "$1" = "androideabi" ]; then
    # arm-linux-androideabi
    mkdir -p $PREFIX/arm-linux-androideabi-$GCC_VERSION_NUMBER
    rm -rf $PREFIX/arm-linux-androideabi-$GCC_VERSION_NUMBER/*
    ./configure --target=arm-linux-androideabi \
        --prefix=$PREFIX/arm-linux-androideabi-$GCC_VERSION_NUMBER \
        --with-binutils-version="$BINUTILS_VERSION" \
        --with-cloog-version="$CLOOG_VERSION" \
        --with-gcc-version="$GCC_VERSION" \
        --with-gdb-version="$GDB_VERSION" \
        --with-gmp-version="$GMP_VERSION" \
        --with-gold-version="$BINUTILS_VERSION" \
        --with-mpfr-version="$MPFR_VERSION" \
        --with-mpc-version="$MPC_VERSION" \
        --with-ppl-version="$PPL_VERSION" \
        --with-isl-version="$ISL_VERSION" \
        --with-tune=cortex-a9 \
        --with-sysroot="$SYSROOT" \
        --target=arm-linux-androideabi \
        --enable-graphite=yes \
        --enable-gold=yes \
        --disable-docs

    make $SMP && make install
    cp -v makefiles/*.mk $PREFIX/arm-linux-androideabi-$GCC_VERSION_NUMBER/
    cp -v makefiles/lib32/*.mk $PREFIX/arm-linux-androideabi-$GCC_VERSION_NUMBER/lib32/
else
    echo "no target"
fi
