#!/bin/bash

#############################################################
## build a single instantOS package and put it in the repo ##
#############################################################

if [ -z "$1" ]; then
    echo "usage: ./singlebuild.sh packagename"
    exit
fi

if ! [ -e ~/workspace/extra ]; then
    echo "downloading extra"
    mkdir ~/workspace
    cd ~/workspace
    git clone --depth=1 https://github.com/instantos/extra
fi

if uname -m | grep -q '^i'; then
    IS32=True
    if ! [ -e ~/workspace/extra ]; then
        echo "downloading extra"
        cd ~/workspace
        git clone --depth=1 https://github.com/instantos/32bit
    fi
fi

if [ -n "$IS32" ]; then
    cd ~/workspace/32bit
    git pull || exit
    cd ..
fi

cd ~/workspace/extra
git pull || exit

if ! [ -e "$1/PKGBUILD" ]; then
    echo "no $1 is not a package"
    exit
fi

# get a full copy of the repo working first
if ! [ -e ~/stuff/extra/build ]; then
    mkdir -p ~/stuff/extra/build
    cd ~/stuff/extra/build
    source ~/workspace/extra/utils/fetchrepo.sh
fi

cd ~/stuff/extra/build
if [ -e "$1".* ]; then
    echo "removing previous version"
    rm "$1".*
fi

mkdir -p ~/.cache/instantos/pkg
cd ~/.cache/instantos/pkg
cp ~/workspace/extra/$1/* .
makepkg

mv *.pkg.tar.xz ~/stuff/extra/build/"$1".pkg.tar.xz

cd
rm -rf .cache/instantos/pkg

~/workspace/extra/utils/postbuild.sh
echo "done building $1"
