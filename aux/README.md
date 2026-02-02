# Auxiliary Applications

This directory contains **everyday, non-development applications** required
for daily communication and general use.

These tools are:
- not part of the base system
- not required for development
- user-facing and replaceable
- installed independently of the package manager when appropriate

Examples:
- chat clients
- media applications
- proprietary binaries
- tools with their own update mechanisms

Each application lives in its own directory and provides its own
`deploy.sh` or install logic.

To use install.sh ensure your shell exports path correctly
.bashrc or .zshrc
```code
export PATH="$HOME/.local/bin:$PATH"
```

This separation keeps the base system clean
and avoids mixing system configuration with user applications.

