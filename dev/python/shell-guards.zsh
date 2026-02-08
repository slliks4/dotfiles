# Prevent accidental global pip installs
pip() {
  if [ -z "$VIRTUAL_ENV" ]; then
    echo "❌ pip blocked outside virtualenv"
    echo "➡️  Use pipenv install or activate a venv"
    return 1
  fi
  command pip "$@"
}
