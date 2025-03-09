#!/bin/bash

[[ ! $(command -v fzf) ]] && echo "Error: You need to have fzf installed" >&2 && return 1
[[ ! $(command -v kubectx) ]] && echo "Error: You need to have kubectx installed" >&2 && return 1
[[ ! $(command -v aws) ]] && echo "Error: You need to have k9s installed" >&2 && return 1

targets="$(echo "kubens kubectx aws" | tr ' ' '\n' | fzf --tac)"
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
    acc="$(aws --no-cli-pager configure list-profiles 2>/dev/null | fzf)"
    echo "${acc}" > ~/.aws/current_acc
    ;;

  *)
    echo "Something went wrong" >&2
    ;;
esac

