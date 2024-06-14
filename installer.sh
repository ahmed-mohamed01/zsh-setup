#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to handle user prompts for yes/no questions
prompt_yes_no() {
    while true; do
        read -p "$1 (y/n): " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer y or n.";;
        esac
    done
}

mkdir logs

# Check if the operating system is Debian-based
if ! command_exists apt; then
    echo "This script is only usable on Debian-based Linux distributions."
    exit 1
fi

# Check if zsh is installed and ask the user if they want to install it
echo -e "\nChecking if Zsh is installed..."
if ! command_exists zsh; then
    if prompt_yes_no "Zsh is not installed. Do you want to install Zsh?"; then
        sudo apt update &> /dev/null
        sudo apt install -y zsh &> /dev/null
        echo -e "\nInstalling Zsh"
    else
        echo "Zsh installation is required for rest of this setup. Exiting."
        exit 1
    fi
fi

if ! command_exists brew; then
    if prompt_yes_no "Brew needs to be installed to ensure up to date versions of bat, fd, fzf, eza and zoxide are installed. Continue?"; then
        echo "Installing Homebrew..."
        yes "" | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &> logs/brew_install.log
        if [ $? -ne 0 ]; then
            echo "Homebrew installation failed. Check logs/brew_install.log for details. Exiting."
            exit 1
        else
            # Detect the shell and initialize Homebrew into the shell
            echo "Initializing Homebrew into the shell..."
            if [ -n "$ZSH_VERSION" ]; then
                eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
                echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
            elif [ -n "$BASH_VERSION" ]; then
                eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
                echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
                source ~/.bashrc  # Make sure to source .bashrc to apply changes
            elif [ -n "$FISH_VERSION" ]; then
                eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
                set -Ux fish_user_paths $fish_user_paths /home/linuxbrew/.linuxbrew/bin
                echo 'set -Ux fish_user_paths $fish_user_paths /home/linuxbrew/.linuxbrew/bin' >> ~/.config/fish/config.fish
            fi
            echo "Homebrew installed."
        fi
    fi
fi

# Inform the user about the installation
echo "The following progams will be installed:"
echo " - Powerlevel10k prompt for Zsh"
echo " - bat"
echo " - fzf"
echo " - fd"
echo " - eza"
echo " - zoxide"
echo "More information can be found at: https://github.com/ahmed-mohamed01/zsh-setup"
if ! prompt_yes_no "Do you want to proceed?"; then
    echo "Installation aborted."
    exit 1
fi

echo -e "Installing dependency build-essential"
sudo apt-get install -y build-essential &> logs/build_essential_install.log
# Installing bat
echo -e "Installing bat..."
brew install bat &> /dev/null
echo -c "Installing eza..."
brew install eza &> /dev/null
echo - "Installing fzf..."
brew install fzf &> /dev/null
echo -e "Installing fd"
brew install fd &> /dev/null
echo -e "Installing zoxide..."
brew install zoxide &> /dev/null
echo "Required programs installed successfully."

# Add spacing for clarity
echo -e "\n"

# Clone the GitHub repository and set up Zsh configuration
echo "Setting up Zsh and P10k configuration..."
cp -r config/. ~/
echo "Zsh settings have been loaded."

# Install MesloLGM Nerd Fonts from the local repository
echo "Installing MesloLGM Nerd Fonts..."
mkdir -p ~/.local/share/fonts
cp fonts/MesloLGMNerdFont-Italic.ttf ~/.local/share/fonts/
cp fonts/MesloLGMNerdFont-Regular.ttf ~/.local/share/fonts/
cp fonts/MesloLGMNerdFont-Bold.ttf ~/.local/share/fonts/
fc-cache -fv &> logs/font_cache.log
echo "MesloLGM Nerd Fonts installed successfully."

# Prompt the user to change the default shell to Zsh
if prompt_yes_no "Change default shell to Zsh?"; then
    chsh -s $(which zsh)
    echo "Default shell changed to Zsh. Please log out and log back in for the change to take effect."
fi

echo "Installation and setup complete."
echo -e "\n"
echo "If  the p10k theme is not to your preference, you can use "p10k configure" to change this."
echo -e "\n"
echo "You can now start zsh. First boot will take some time as P10K, ZINIT and plugins will be installed on boot."
echo -e "\n"
if prompt_yes_no "Ready to start Zsh. First load will take some time as settings are applied. Continue?"; then
    exec zsh
fi
