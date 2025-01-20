#!/bin/bash

[[ ! $(command -v fzf) ]] && echo "Error: You need to have fzf installed" >&2 && return 1
[[ ! $(command -v tfenv) ]] && echo "Error: You need to have tfenv installed" >&2 && return 1

target="$(echo "terraform java" | tr ' ' '\n' | fzf)"
if [[ -z "${target}" ]]; then
  exit 1
fi

case "${target}" in
  "terraform")
    version="$(tfenv list-remote | fzf)"
    tfenv install "${version}"
    tfenv use "${version}"
    ;;
  "java")
    version="$(echo "11 17 21 23" | tr ' ' '\n' | fzf)"
    case "${version}" in
        "11")
            export JAVA_HOME=$JAVA_11_HOME
            sed -E -i '' "s/^export JAVA_HOME=.*/export JAVA_HOME=\$JAVA_11_HOME/" $XDG_DOCUMENTS_DIR/projects/common/.dotfiles/.zshrc
            ;;
        "17")
            sed -E -i '' "s/^export JAVA_HOME=.*/export JAVA_HOME=\$JAVA_17_HOME/" $XDG_DOCUMENTS_DIR/projects/common/.dotfiles/.zshrc
            ;;
        "21")
            sed -E -i '' "s/^export JAVA_HOME=.*/export JAVA_HOME=\$JAVA_21_HOME/" $XDG_DOCUMENTS_DIR/projects/common/.dotfiles/.zshrc
            ;;
        "23")
            sed -E -i '' "s/^export JAVA_HOME=.*/export JAVA_HOME=\$JAVA_23_HOME/" $XDG_DOCUMENTS_DIR/projects/common/.dotfiles/.zshrc
            ;;
        *)
            echo "Usage: use_java {11|17|21|23}"
            return 1
            ;;
    esac
    ;;
  *)
    echo "Something went wrong" >&2
    ;;
esac

