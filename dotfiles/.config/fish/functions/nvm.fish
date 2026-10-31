function nvm --description "nvm — delegates to the system nvm (bash) and applies it to fish"
    set -l init /usr/share/nvm/init-nvm.sh
    if not test -f $init
        echo "nvm: $init not found (install the 'nvm' package)" >&2
        return 127
    end

    set -q NVM_DIR; or set -gx NVM_DIR "$HOME/.config/nvm"

    # init-nvm.sh is bash-only and fish cannot source it. Run it in a bash
    # subprocess, then replay the environment it produced (PATH and the NVM_*
    # variables) back into this fish session, so `nvm use` actually takes
    # effect here.
    set -l out (env NVM_DIR=$NVM_DIR bash --noprofile --norc -c '
        . "$1" >/dev/null 2>&1
        shift
        nvm "$@"
        __nvm_rc=$?
        printf "@@NVM_RC=%s\n" "$__nvm_rc"
        printf "@@NVM_DIR=%s\n" "${NVM_DIR-}"
        printf "@@NVM_BIN=%s\n" "${NVM_BIN-}"
        printf "@@NVM_INC=%s\n" "${NVM_INC-}"
        printf "@@NVM_PATH=%s\n" "$PATH"
    ' nvm $init $argv)

    set -l rc 0
    for line in $out
        switch $line
            case '@@NVM_RC=*'
                set rc (string replace '@@NVM_RC=' '' -- $line)
            case '@@NVM_PATH=*'
                set -gx PATH (string split ':' -- (string replace '@@NVM_PATH=' '' -- $line))
            case '@@NVM_DIR=*'
                set -gx NVM_DIR (string replace '@@NVM_DIR=' '' -- $line)
            case '@@NVM_BIN=*' '@@NVM_INC=*'
                set -l parts (string split -m1 '=' -- (string replace '@@' '' -- $line))
                if test -n "$parts[2]"
                    set -gx $parts[1] $parts[2]
                else
                    set -e $parts[1]
                end
            case '*'
                echo $line
        end
    end

    return $rc
end
