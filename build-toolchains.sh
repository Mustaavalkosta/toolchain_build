#!/bin/bash
BUILD="x86_64-linux-gnu"
HOST="x86_64-linux-gnu"
PREFIX="/home/mustaavalkosta/pizzabean/prebuilts/gcc/linux-x86/arm"
GCC_VERSION_NUMBER="4.8"
GCC_VERSION="4.8"
BINUTILS_VERSION="2.23.2"
GMP_VERSION="5.1.2"
MPFR_VERSION="3.1.2"
MPC_VERSION="1.0.1"
GDB_VERSION="linaro-7.6-2013.05"
CLOOG_VERSION="0.18.0"
PPL_VERSION="1.0"
ISL_VERSION="0.12"
SYSROOT="/"

if [ "$1" = "eabi" ]; then
    # arm-eabi
    mkdir -p $PREFIX/arm-eabi-$GCC_VERSION_NUMBER
    rm -rf $PREFIX/arm-eabi-$GCC_VERSION_NUMBER/*
    ./configure \
        --target=arm-eabi \
        --build=$BUILD \
        --host=$HOST \
        --prefix=$PREFIX/arm-eabi-$GCC_VERSION_NUMBER \
        --with-gcc-version=$GCC_VERSION \
        --with-binutils-version=$BINUTILS_VERSION \
        --with-gmp-version=$GMP_VERSION \
        --with-mpfr-version=$MPFR_VERSION \
        --with-mpc-version=$MPC_VERSION \
        --with-gdb-version=$GDB_VERSION \
        --with-cloog-version=$CLOOG_VERSION \
        --with-ppl-version=$PPL_VERSION \
        --with-isl-version=$ISL_VERSION \
        --enable-graphite \
        --enable-gold=default \
        --disable-docs

    make -j6 build && make install

elif [ "$1" = "androideabi" ]; then
    # arm-linux-androideabi
    mkdir -p $PREFIX/arm-linux-androideabi-$GCC_VERSION_NUMBER
    rm -rf $PREFIX/arm-linux-androideabi-$GCC_VERSION_NUMBER/*
    ./configure --target=arm-linux-androideabi \
        --build=x86_64-linux-gnu \
        --host=x86_64-linux-gnu \
        --prefix=$PREFIX/arm-linux-androideabi-$GCC_VERSION_NUMBER \
        --with-gcc-version=$GCC_VERSION \
        --with-binutils-version=$BINUTILS_VERSION \
        --with-gmp-version=$GMP_VERSION \
        --with-mpfr-version=$MPFR_VERSION \
        --with-mpc-version=$MPC_VERSION \
        --with-gdb-version=$GDB_VERSION \
        --with-cloog-version=$CLOOG_VERSION \
        --with-ppl-version=$PPL_VERSION \
        --with-isl-version=$ISL_VERSION \
        --enable-graphite \
        --enable-gold=default \
        --with-sysroot=$SYSROOT \
        --disable-docs

    make -j6 build && make install
else
    echo "no target"
fi
