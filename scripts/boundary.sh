#!/bin/bash

[[ ! $(command -v jq) ]] && { echo "Error: You need to have jq installed" >&2; exit 1; }
[[ ! $(command -v fzf) ]] && { echo "Error: You need to have fzf installed" >&2; exit 1; }
[[ ! $(command -v boundary) ]] && { echo "Error: You need to have boundary installed" >&2; exit 1; }

boundary_search_target_by_name_exact() {
  [[ -z "$1" ]] && echo "Usage: boundary_search_target_by_name_exact <target-name>" && return 1
  boundary targets list -recursive | grep -B 4 -A 4 "$1"
}

token="$(boundary authenticate 2>&1 | tail -n 3 | head -n 1)"
if [[ -z "${token}" ]]; then
  echo "Failed to authenticate" >&2
  exit 1
fi
echo "Token: ${token}"
export BOUNDARY_TOKEN="${token}"
export BOUNDARY_TOKEN_NAME="${token}"

target="$(echo "argo status close" | tr ' ' '\n' | fzf)"
if [[ -z "${target}" ]]; then
  echo "No target selected" >&2
  exit 1
fi

env="$(echo "dev test perf staging prod tools" | tr ' ' '\n' | fzf)"
if [[ -z "${env}" ]]; then
  echo "No env selected" >&2
  exit 1
fi


if [[ "${target}" == "argo" ]]; then
  case "${env}" in
    "dev")
      ARGO_TARGET_NAME="ArgoCD UI (Dev)"
      ;;
    "test")
      ARGO_TARGET_NAME="ArgoCD UI (Test)"
      ;;
    "perf")
      ARGO_TARGET_NAME="ArgoCD UI (Perf)"
      ;;
    "staging")
      ARGO_TARGET_NAME="ArgoCD UI (Staging)"
      ;;
    "prod")
      ARGO_TARGET_NAME="ArgoCD UI (Prod)"
      ;;
    "tools")
      ARGO_TARGET_NAME="ArgoCD UI (Tools)"
      ;;
    *)
      echo "Wrong env" >&2
      exit 1
      ;;
  esac
fi

case "${target}" in
  "argo")
    port="8080"
    ARGO_TARGET_ID="$(boundary_search_target_by_name_exact "${ARGO_TARGET_NAME}" | head -n 1 | rev | cut -d ' ' -f 1 | rev)"
    echo "ArgoCD target ID: ${ARGO_TARGET_ID}"
    [[ -n "${ARGO_TARGET_ID}" ]] && boundary connect -target-id "${ARGO_TARGET_ID}" -listen-port ${port} 
    ;;
  "status")
    boundary sessions list -recursive
    read
    ;;
  "close")
    SESSION_IDS="$(boundary sessions list -recursive | tail -n +3 | grep "  ID:" | rev | cut -d ' ' -f 1 | rev)"
    for SESSION_ID in "${SESSION_IDS}"; do
      boundary sessions cancel -id "${SESSION_ID}"
    done
    ;;
  *)
    echo "Wrong target" >&2
    exit 1
    ;;
esac

