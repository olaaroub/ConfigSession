#!/bin/bash
set -e

echo "Updating dependencies.."

sudo apt update
sudo apt upgrade
sudo apt install -y git curl zsh
chsh -s $(which zsh) #makes zsh your default shell
echo "installing oh-my-zsh.."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Installing Kitty terminal..."

curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
# Create symbolic links to add kitty and kitten to PATH (assuming ~/.local/bin is in
# your system-wide PATH)
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
# Place the kitty.desktop file somewhere it can be found by the OS
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
# If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
# Update the paths to the kitty and its icon in the kitty desktop file(s)
sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
# Make xdg-terminal-exec (and hence desktop environments that support it use kitty)
echo 'kitty.desktop' > ~/.config/xdg-terminals.list


echo "Creating basic kitty.conf"
cat > ~/.config/kitty/kitty.conf << EOF
# terminal startup mode 
startup_session ~/.config/kitty/sessions/startup.conf

remember_window_size  no
initial_window_width  1366
initial_window_height 768

hide_window_decorations yes


font_family FiraCodeNerdFont
italic_font auto
bold_italic_font auto
font_size 10
# url_color #d65c9d
detect_urls yes
url_prefixes file ftp ftps gemini git gopher http https irc ircs kitty mailto news sftp ssh
open_url_with default
url_style curly
cursor #8fee96
copy_on_select yes


cursor_shape underline
cursor_underline_thickness 2.0


term xterm-256color

background_opacity 0.4
# color0 #000000
# color8 #767676
# color1 #cc0403
# color9 #f2201f
# color2  #19cb00
# color10 #23fd00
# color3  #cecb00
# color11 #fffd00
# color4  #0d73cc
# color12 #1a8fff
# color5  #cb1ed1
# color13 #fd28ff
# color6  #0dcdcd
# color14 #14ffff
# color7  #dddddd
# color15 #ffffff




# BEGIN_KITTY_THEME
# Vibrant Ink
include current-theme.conf
# END_KITTY_THEME
EOF

# Method 2: Create file from heredoc
cat << EOF > ~/.config/kitty/shortcuts.conf
# Keyboard shortcuts
map cmd+c        copy_to_clipboard
map cmd+v        paste_from_clipboard
map ctrl+shift+t new_tab
EOF

# Method 3: Generate file with dynamic content
CURRENT_DATE=$(date +"%Y-%m-%d")
cat > ~/.config/kitty/version_info.conf << EOF
# Auto-generated config
kitty_version $(kitty --version)
config_created $CURRENT_DATE
user $USER
EOF

# Method 4: Append to existing file
echo -e "\n# Custom prompt style" >> ~/.config/kitty/kitty.conf
echo "shell_integration enabled" >> ~/.config/kitty/kitty.conf

# ==================================================================
# Advanced File Operations
# ==================================================================

# Create directory structure
mkdir -p ~/.config/kitty/themes

# Create theme file using variable
THEME_CONTENT=$(cat << EOF
# Solarized Dark Theme
foreground #839496
background #002b36

color0  #073642
color1  #dc322f
color2  #859900
EOF
)

echo "$THEME_CONTENT" > ~/.config/kitty/themes/solarized_dark.conf

# Create backup of existing config
CONFIG_PATH="$HOME/.config/kitty/kitty.conf"
if [ -f "$CONFIG_PATH" ]; then
    cp "$CONFIG_PATH" "$CONFIG_PATH.backup-$(date +%Y%m%d%H%M%S)"
fi

# ... [rest of your original script] ...