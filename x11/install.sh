#!/bin/sh
# --------------------------------------------------
# X11 + dwm installation script
# Source-based dwm (fork workflow)
# --------------------------------------------------

set -e

# --------------------------------------------------
# Configuration
# --------------------------------------------------

DWM_SRC_DIR="/usr/local/src/dwm"
DWM_REPO="https://github.com/slliks4/dwm.git"
AUR_DIR="$HOME/aur"

# --------------------------------------------------
# Helpers
# --------------------------------------------------

section() {
  echo ""
  echo "==> $1"
}

pkg_installed() {
  pacman -Qi "$1" >/dev/null 2>&1
}

# --------------------------------------------------
# Required pacman packages
# --------------------------------------------------

section "Checking system dependencies"

PKGS=""

# X11 base
pkg_installed xorg-server || PKGS="$PKGS xorg-server"
pkg_installed xorg-xinit  || PKGS="$PKGS xorg-xinit"

# Build tools
pkg_installed base-devel || PKGS="$PKGS base-devel"

# dwm build dependencies
pkg_installed libx11      || PKGS="$PKGS libx11"
pkg_installed libxinerama || PKGS="$PKGS libxinerama"
pkg_installed libxft      || PKGS="$PKGS libxft"

# Terminal
pkg_installed alacritty || PKGS="$PKGS alacritty"

# Fonts
pkg_installed fontconfig    || PKGS="$PKGS fontconfig"
pkg_installed terminus-font || PKGS="$PKGS terminus-font"
pkg_installed ttf-dejavu    || PKGS="$PKGS ttf-dejavu"

if [ -n "$PKGS" ]; then
  section "Installing missing packages"
  sudo pacman -S --needed $PKGS
else
  echo "✓ All required packages already installed"
fi

# --------------------------------------------------
# Install paru (AUR helper) if missing
# --------------------------------------------------

if ! command -v paru >/dev/null 2>&1; then
  section "Installing paru (AUR helper)"

  mkdir -p "$AUR_DIR"
  cd "$AUR_DIR"

  if [ ! -d paru ]; then
    git clone https://aur.archlinux.org/paru.git
  fi

  cd paru
  makepkg -si --noconfirm
else
  echo "✓ paru already installed"
fi

# --------------------------------------------------
# Optional retro fonts (AUR)
# --------------------------------------------------

section "Installing optional retro fonts (AUR)"
paru -S --needed --noconfirm spleen-font tamsyn-font || true

# --------------------------------------------------
# Prepare source directory
# --------------------------------------------------

section "Preparing /usr/local/src"

sudo mkdir -p /usr/local/src
sudo chown "$USER:$USER" /usr/local/src

# --------------------------------------------------
# Clone dwm fork
# --------------------------------------------------

section "Installing dwm from fork"

if [ ! -d "$DWM_SRC_DIR" ]; then
  cd /usr/local/src
  git clone "$DWM_REPO"
else
  echo "✓ dwm source already exists"
fi

# --------------------------------------------------
# Build and install dwm
# --------------------------------------------------

section "Building and installing dwm"

cd "$DWM_SRC_DIR"
sudo make clean install

# --------------------------------------------------
# Ensure ~/.xinitrc exists
# --------------------------------------------------

section "Ensuring ~/.xinitrc"

if [ ! -f "$HOME/.xinitrc" ]; then
  cat > "$HOME/.xinitrc" << 'EOF'
#!/bin/sh
exec dwm
EOF
  chmod +x "$HOME/.xinitrc"
  echo "✓ Created ~/.xinitrc"
else
  echo "✓ ~/.xinitrc already exists (not modified)"
fi

# --------------------------------------------------
# Done
# --------------------------------------------------

echo ""
echo "✅ dwm installation complete"
echo ""
echo "Next steps:"
echo "  1) Switch to a TTY"
echo "  2) Run: startx"
echo ""
echo "If dwm launches, X11 bring-up is successful."
