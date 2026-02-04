#!/bin/bash

[[ ! $(command -v fzf) ]] && echo "Error: You need to have fzf installed" >&2 && return 1
[[ ! $(command -v kubectx) ]] && echo "Error: You need to have kubectx installed" >&2 && return 1
[[ ! $(command -v aws) ]] && echo "Error: You need to have k9s installed" >&2 && return 1

targets="$(echo "python kubens kubectx aws" | tr ' ' '\n' | fzf --tac)"
if [[ -z "${targets}" ]]; then
  exit 1
fi

case "${targets}" in
  "kubens")
    kubens
    ;;
  "kubectx")
    kubectx
    ;;
  "aws")
    aws configure sso
    ;;

  *)
    echo "Something went wrong" >&2
    ;;
esac
