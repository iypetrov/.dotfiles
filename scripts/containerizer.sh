#!/bin/bash

[[ ! $(command -v fzf) ]] && echo "Error: You need to have fzf installed" >&2 && return 1
# [[ ! $(command -v docker) ]] && echo "Error: You need to have docker installed" >&2 && return 1
[[ ! $(command -v kubectx) ]] && echo "Error: You need to have kubectx installed" >&2 && return 1
[[ ! $(command -v k9s) ]] && echo "Error: You need to have k9s installed" >&2 && return 1

# target="$(echo "docker k8s" | tr ' ' '\n' | fzf)"
# if [[ -z "${target}" ]]; then
#   exit 1
# fi
#
# case "${target}" in
#   "docker")
#     target_docker="$(echo "config lazydocker" | tr ' ' '\n' | fzf)"
#     case "${target_docker}" in
#       "config")
#         target_docker_ctx="$(docker context ls --format {{.Name}} | fzf)"
#         if [[ -z "${target_docker_ctx}" ]]; then
#           exit 1
#         fi
#
#         docker context use "${target_docker_ctx}"
#         ;;
#       "lazydocker")
#         lazydocker
#         ;;
#       *)
#         echo "Something went wrong" >&2
#         ;;
#     esac
#     ;;
#   "k8s")
    target_k8s="$(echo "kubectx kubens k9s" | tr ' ' '\n' | fzf --tac)"
    if [[ -z "${target_k8s}" ]]; then
      exit 1
    fi

    case "${target_k8s}" in
      "kubectx")
        kubectx
        ;;
      "kubens")
        kubens
        ;;
      "k9s")
        k9s
        ;;
      *)
        echo "Something went wrong" >&2
        ;;
    esac
#     ;;
#   *)
#     echo "Something went wrong" >&2
#     ;;
# esac
