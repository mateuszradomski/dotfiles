#!/bin/sh

NEOVIM_BINARY_URL="https://github.com/neovim/neovim/releases/download/v0.7.0/nvim.appimage"
NEOVIM_BINARY_PATH="$HOME/.local/bin/nvim"

BASE_URL="https://raw.githubusercontent.com/mateuszradomski/dotfiles/master"
TMUX_CONF_PATH="$HOME/.tmux.conf"
NVIM_INIT_PATH="$HOME/.config/nvim/init.vim"
GITCONFIG_GLOB_PATH="$HOME/.gitconfig"
GITIGNORE_GLOB_PATH="$HOME/.gitignore_global"

YELLOW='\033[93m'
GREEN='\033[92m'
RESET='\033[0m'

# Download my dotfiles
curl --proto '=https' --tlsv1.2 --silent --location $BASE_URL/.tmux.conf --create-dirs --output $TMUX_CONF_PATH
curl --proto '=https' --tlsv1.2 --silent --location $BASE_URL/init.vim --create-dirs --output $NVIM_INIT_PATH

if [ "$GIT" = "true" ]
then
    curl --proto '=https' --tlsv1.2 --silent --location $BASE_URL/.gitconfig --create-dirs --output $GITCONFIG_GLOB_PATH
    curl --proto '=https' --tlsv1.2 --silent --location $BASE_URL/.gitignore_global --create-dirs --output $GITIGNORE_GLOB_PATH
fi

echo -e $YELLOW"Downloaded the config files"$RESET

# Remove the old nvim
rm -rf $(which nvim)

# Download the chosen neovim version and install it locally
curl --proto '=https' --tlsv1.2 --silent --location $NEOVIM_BINARY_URL --create-dirs --output $NEOVIM_BINARY_PATH
chmod +x $NEOVIM_BINARY_PATH

echo -e $YELLOW"Downloaded the neovim binary"$RESET
 
# Download the vim-plug [https://github.com/junegunn/vim-plug]
curl --proto '=https' --tlsv1.2 --silent -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo -e $YELLOW"Downloaded the vim-plug"$RESET

# To ignore errors export only pluged files
PLUG_TMP_FILE=$(mktemp)
awk '/plug#begin/,/plug#end/' $NVIM_INIT_PATH > $PLUG_TMP_FILE
$NEOVIM_BINARY_PATH -u $PLUG_TMP_FILE --headless +PlugInstall +qall &> /dev/null
rm $PLUG_TMP_FILE

echo -e $YELLOW"Downloaded all plugins"$RESET

# Change the default editor to nvim  
# remove the old alias if already created
sed '/alias vim/d' -i $HOME/.bashrc 
echo 'alias vim=nvim' >> $HOME/.bashrc

echo -e $GREEN"Finished, happy coding..."$RESET
