# zsh-setup
This repo will store the set up files and settings for zsh so that I can get up and running quickly, when I foolishly mess something up. 

### Demo


### Features
- ZSH under the hood, which is fast and well supported. 
- P10K prompt/theme - clean and easy to use.
- Uses zinit as package manager - quick and less overhead. 
- FISH like zsh-autosuggestions will autofill commands as you type, and learn as you use ZSH more.
- zsh-syntax-highlighting applied to make commands easier to follow.
- [Zoxide](https://github.com/ajeetdsouza/zoxide) will allow ``` cd ``` replacement, and support autojump
- [Fzf](https://github.com/junegunn/fzf) will allow rapid navigation and ability to find and open files quickly. This can be used to open files quickly using vim / nano (eg ```$ nvim ** ``` + ```<tab>``` ), or search through your previous commands (ctrl + r)

### 1. ZSH setup

Quick version: 
```bash
# Clone this repo
git clone https://github.com/ahmed-mohamed01/zsh-setup

# Run installer. This will verify that you want to install the main packages. 
cd zsh-setup
chmod +x ./installer-less-prompts.sh ./install-fullprompt.sh  # Makes the scripts executable. 
./install-fullprompt.sh

# For an unattended setup, run:
yes "y" | installer-less-prompts.sh
```
## Manual Installation

### 1. Install zsh
On debian based linux distros, install using:
```bash
sudo apt update
sudo apt install -y zsh
```
#### When you open ZSH for the first time, it will try to guide you through an extensive set-up process. Press 2 to accept defaults. We will be changing all of this anyway. 

### 2. Install Brew
``` apt ``` and ``` snap ``` package managers on Ubuntu/Pop-os have older versoins of packages like zoxide, fzf and fd that we are going to be using. I use [homebrew](https://brew.sh/) to make sure I have uptodate versions of packages.

Installation (obtained from Homebrew website:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

If you are using bash, initialize brew by:
```bash
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```
<details>

<summary> For other Shells </summary>

For FISH
```bash
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"  # Initiates brew for current session.
set -Ux fish_user_paths $fish_user_paths /home/linuxbrew/.linuxbrew/bin  # Adds to FISH path. 
echo 'set -Ux fish_user_paths $fish_user_paths /home/linuxbrew/.linuxbrew/bin' >> ~/.config/fish/config.fish
```
For ZSH
```bash
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
```
</details>

### 3. Install zoxide, fzf, fd, exa using brew

<details>

<summary> A brief summary for these programs</summary>

3a. ``` zoxide ``` -  alternative to ``` cd ``` written in Rust, with autojump like support.
- lets you navigate as normal with cd (eg: ``` $ cd /home/user/audiobookshelf ```)
- if you have visited the folder before, it can jump to that folder. (eg, while at root folder, you can type ``` $ cd audiobook ``` to jump to ``` /home/user/audiobookshelf ``` )
- as you can see from the above, zoxide can do fuzzy matching, so you do not need to type in full folder name. Parts of path can be used ``` $ cd ho lin br ```  can resolve to ``` /home/linuxbrew/.linuxbrew/bin/brew ``` if you have opened it before. 
- More information https://github.com/ajeetdsouza/zoxide

3b. ``` fzf ``` - fuzzy finder using GNU find, allows you to rapidly search for and natigate to/open files and folders.
- [Fzf](https://github.com/junegunn/fzf) is a versatile fuzzy finder, writen in GO 
- Can be used to rapidly seatch through files and folders. eg ```$ cd ** ``` + press ``` <tab> ``` will allow you to open a fzf prompt to fuzzy search directories from current folder. ```$ cd /mnt** <tab> ``` will allow you to search from the /mnt folder. ```$ vi ** <tab> ``` will allow you to search for and open files using vim, from current folder. 

3c. ``` fd ``` - replacement for ``` GNU find ``` that we are going to use with fzf. 
- [fd](https://github.com/sharkdp/fd) is included as it is Faster, more versatile and respects ```.ignore ``` & ```.gitignore```.

3d. ``` bat ``` - replacement for ```cat``` with syntax highlighting. 
- [Bat](https://github.com/sharkdp/bat) will be to provide previews in fzf searches. 

3e. ``` eza ``` --> replacement for ```ls```, 
- [Eza](https://github.com/eza-community/eza) ciomes with categorical colors and icons for files and tree view support. This is a fork of [exa](https://the.exa.website/).
- It just makes things look cleaner, IMO.

</details>

Install these using:

```bash
brew install bat eza fd fzf zoxide 
```
### 4. Set up ZSH using .zshrc

The given .zshrc will contain settings to install [Power10K](https://github.com/romkatv/powerlevel10k) prompt on first boot and and initialize it, as well as initialize rest of the apps mentioned above, in zsh. 

<details>

<summary> It will also: </summary>


1. Sets up sane defaults for ZSH, including emac keybindings, history size etc. so you don't have to go through the lenghty set-up process. 
2. Install and  ```zinit``` as ZSH package manager. 
3. Uses zinit to install ZSH plugins - ``` autosuggestions ```, ``` fast-syntax-highligting ```, ``` fzf-tab ```, ``` zsh-completions```
 
4. Set up alias for ``` eza ``` so that it replaces ``` ls ```, with icons. (also ```lst``` which will give a tree view, depth = 2)
5. Set alias for ``` zoxide ``` so that it replaces ``` cd ```
6. Set keybindings for ``` fzf ``` --> By emacs keybindings by default. 
7. Use the default theme settings I have made for P10k. TO change these settings, use ```$p10k configure```
</details>

```bash
# Copy the .zshrc from this repo.
git clone https://github.com/ahmed-mohamed01/zsh-setup.git
cd zsh-setup

# Copy ZSH settings and Power10K Prompt settings to Home folder. 
mv ~/.zshrc ~/.zshrc-orig  # Optional, back up any existing zshrc
cp .zshrc .p10k.zsh ~/
```

### 5. Install NerdFont.
Either download and install a font from https://www.nerdfonts.com/, or use the command below, to install MesloLGM Nerd Font.

Or Install fonts in the Fonts folder in the repo. 

```bash
mkdir -p ~/.local/share/fonts
curl -fLo "$HOME/.local/share/fonts/MesloLGM NF Regular.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/L/Regular/MesloLGM%20NF%20Regular.ttf
fc-cache -fv
```

### Initialize .zshrc
```bash
source ~/.zshrc
exec zsh
```
This will apply the settings from zshrc, and p10k.zsh.

### 6. Set ZSH as default shell.
```bash
chsh -s $(which zsh)
```

Thats it, all done. 