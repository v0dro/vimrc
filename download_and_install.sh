#!/bin/bash

set -e

C_COMPILER=gcc
CXX_COMPILER=g++
FC_COMPILER=gfortran
ROOT_FOLDER=`pwd`

if [ ! -d vim ]; then
	git clone https://github.com/vim/vim.git
fi

curl https://ftp.gnu.org/gnu/ncurses/ncurses-6.4.tar.gz -o ncurses.tar.gz
tar xvf ncurses.tar.gz

pushd ncurses-6.4
	mkdir -p build
	CC=$C_COMPILER CXX=$CXX_COMPILER FC=$FC_COMPILER ./configure --prefix=`pwd`/build
	make -j install
popd

pushd vim
	CC=$C_COMPILER CXX=$CXX_COMPILER FC=$FC_COMPILER \
		CFLAGS="-I$ROOT_FOLDER/ncurses-6.4/build/include" \
		LDFLAGS="-L$ROOT_FOLDER/ncurses-6.4/build/lib" \
		./configure --prefix=`pwd`/build

	make -j install
popd

mv vim/build .

echo "Change your $PATH like this:"
echo "export \$PATH=\$PATH:$ROOT_FOLDER/build/bin"
