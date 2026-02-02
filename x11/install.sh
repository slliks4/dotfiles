#!/bin/sh

set -e

# --------------------------
# Paths / Config
# --------------------------
DWM_SRC_DIR="/usr/local/src/dwm"
DWM_REPO="https://github.com/slliks4/dwm.git"
AUR_DIR="$HOME/aur"

# --------------------------
# Helpers
# --------------------------
check_dep() {
  command -v "$1" >/dev/null 2>&1
}

echo_section() {
  echo ""
  echo "==> $1"
}

install_pkgs=""
aur_pkgs=""

# --------------------------
# Package Checks
# --------------------------

# X11 base
check_dep Xorg     || install_pkgs="$install_pkgs xorg-server"
check_dep startx   || install_pkgs="$install_pkgs xorg-xinit"

# Build deps
check_dep gcc      || install_pkgs="$install_pkgs base-devel"
check_dep make     || install_pkgs="$install_pkgs base-devel"
check_dep pkgconf  || install_pkgs="$install_pkgs base-devel"

check_dep alacritty || install_pkgs="$install_pkgs alacritty"

# Fonts
check_dep fc-list  || install_pkgs="$install_pkgs fontconfig"
check_dep terminus-font || install_pkgs="$install_pkgs terminus-font"
check_dep ttf-dejavu || install_pkgs="$install_pkgs ttf-dejavu"

# AUR helper
check_dep paru || aur_pkgs="$aur_pkgs paru"

# --------------------------
# Install Pacman Packages
# --------------------------
if [ -n "$install_pkgs" ]; then
  echo_section "Installing system packages"
  sudo pacman -S --needed $install_pkgs
fi

# --------------------------
# Install paru (AUR helper)
# --------------------------
if ! check_dep paru; then
  echo_section "Installing paru (AUR helper)"
  mkdir -p "$AUR_DIR"
  cd "$AUR_DIR"

  if [ ! -d "$AUR_DIR/paru" ]; then
    git clone https://aur.archlinux.org/paru.git
  fi

  cd paru
  makepkg -si --noconfirm
fi

# --------------------------
# Optional Retro Fonts (AUR)
# --------------------------
echo_section "Installing optional retro fonts (AUR)"
paru -S --needed --noconfirm spleen-font tamsyn-font || true

# --------------------------
# Prepare dwm source dir
# --------------------------
echo_section "Preparing dwm source directory"

if [ ! -d "/usr/local/src" ]; then
  sudo mkdir -p /usr/local/src
fi

sudo chown -R "$USER:$USER" /usr/local/src

# --------------------------
# Clone dwm fork
# --------------------------
echo_section "Installing dwm from fork"

if [ ! -d "$DWM_SRC_DIR" ]; then
  cd /usr/local/src
  git clone "$DWM_REPO"
fi

# --------------------------
# Build + install dwm
# --------------------------
echo_section "Building dwm"

cd "$DWM_SRC_DIR"
sudo make clean install

# --------------------------
# Create .xinitrc
# --------------------------
echo_section "Creating ~/.xinitrc"

if [ ! -f "$HOME/.xinitrc" ]; then
  cat > "$HOME/.xinitrc" << 'EOF'
#!/bin/sh
exec dwm
EOF
  chmod +x "$HOME/.xinitrc"
else
  echo "ℹ ~/.xinitrc already exists — not overwriting"
fi

# --------------------------
# Done
# --------------------------
echo ""
echo "✅ X11 base + dwm installation complete"
echo ""
echo "Next step:"
echo "  → Log into a TTY"
echo "  → Run: startx"
echo ""
echo "If dwm starts successfully, X11 bring-up is complete."
