# Node version manager (Arch package: nvm).
#
# The system package ships /usr/share/nvm/init-nvm.sh, which is bash-only and
# cannot be sourced by fish. functions/nvm.fish delegates to it instead, so fish
# and bash share one set of installed Node versions.
#
# This file only sets up the directory nvm expects and the symlinks it looks
# for; the `nvm` function is autoloaded on first use.

if not set -q NVM_DIR
    set -gx NVM_DIR "$HOME/.config/nvm"
end

test -d "$NVM_DIR"; or mkdir -p "$NVM_DIR"

# init-nvm.sh creates these in bash; "nvm exec" and some scripts expect them.
if test -f /usr/share/nvm/nvm.sh
    test -e "$NVM_DIR/nvm.sh"; or ln -s /usr/share/nvm/nvm.sh "$NVM_DIR/nvm.sh"
    test -e "$NVM_DIR/nvm-exec"; or ln -s /usr/share/nvm/nvm-exec "$NVM_DIR/nvm-exec"
end
