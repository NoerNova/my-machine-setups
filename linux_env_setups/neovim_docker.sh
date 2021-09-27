#!/bin/bash
set -e

# NEOVIM docker - ubuntu image
# Author: noernova
# Date: Jul 25, 2021
# Contact: noernova.com
# Github: https://github.com/noernova
# ===========================================================================

echo ""
echo "##############"
echo "### NEOVIM ###"
echo "##############"
echo ""

# SETUP Temp folder
SETUPDIR=$(pwd)
[ ! -d $SETUPDIR/temp ] && mkdir $SETUPDIR/temp
SETUPTEMP=$SETUPDIR/temp

# Update
echo ""
echo "### Updating ... ####"
echo ""

sudo apt update

# Install require modules and packages
sudo apt install ruby rubygems ruby-dev curl git gzip --yes

# Install more require moduleds by ubuntu running on docker
sudo apt install gcc build-essential cmake pkg-config libtool libtool-bin gettext --yes

# ----------------------------------------------------------------------------

# Tree-Sitter
echo ""
echo "### TREE-SITTER installing ... ###"
echo ""

cd $SETUPTEMP
curl -LO https://github.com/tree-sitter/tree-sitter/releases/download/v0.20.0/tree-sitter-linux-x64.gz
gzip -d tree-sitter-linux-x64.gz
sudo chmod +x tree-sitter-linux-x64
sudo mv tree-sitter-linux-x64 /usr/bin/tree-sitter

cd $SETUPDIR

# luajit
echo ""
echo ""
echo "### Luajit installing ... ####"
echo ""

sudo apt install luajit --yes

# neovim
echo ""
echo ""
echo "### NEOVIM installing ... ###"
echo ""

# appImage not work, require fuselib
# so let self build and install
cd $SETUPDIR
git clone https://github.com/neovim/neovim
cd neovim
sudo make CMAKE_BUILD_TYPE=Release install

# vim-plug
echo ""
echo ""
echo "### VIM-PLUG installing ... ###"
echo ""

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'


cd $SETUPDIR
mkdir ~/.config
cp -r nvim ~/.config/

nvim +PlugInstall +qa

# Clean temps
rm -rf $SETUPTEMP
SETUPTEMP=
SETUPDIR=

echo "NEOVIM, setup finished."

# ----------------------------------------------------------------------------------------------