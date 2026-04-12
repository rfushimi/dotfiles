#!/bin/bash
# Claude Code PreToolUse hook for Bash.
# Reads a JSON payload on stdin and blocks obviously destructive commands.
# Exit 2 = deny (message in stderr is shown to the user and Claude).
# Anything else = allow.
set -euo pipefail

payload=$(cat)
cmd=$(printf '%s' "$payload" | jq -r '.tool_input.command // empty')

deny() {
    printf 'guard-destructive-bash: refusing: %s\n' "$1" >&2
    exit 2
}

case "$cmd" in
    *"rm -rf /"*|*"rm -rf /*"*|*"rm -fr /"*)
        deny "rm -rf of /"
        ;;
    *'rm -rf ~'*|*'rm -rf $HOME'*|*'rm -rf ${HOME}'*|*'rm -fr ~'*|*'rm -fr $HOME'*)
        deny "rm -rf of \$HOME"
        ;;
    *':(){ :|:& };:'*|*':(){:|:&};:'*)
        deny "fork bomb"
        ;;
    *'git push --force'*|*'git push -f '*|*'git push -f'$'\t'*)
        case "$cmd" in
            *' main'*|*' master'*|*':main'*|*':master'*)
                deny "force push to main/master"
                ;;
        esac
        ;;
    *'chmod -R 777 /'*|*'chmod 777 /'*)
        deny "world-writable root"
        ;;
    *'dd '*'of=/dev/'[sn][dv]*)
        deny "dd to a raw block device"
        ;;
esac

exit 0
