#!/bin/bash

[[ ! $(command -v fzf) ]] && echo "Error: You need to have fzf installed" >&2 && return 1

target="$(echo "access.gas-x.de ip812" | tr ' ' '\n' | fzf --tac)"
if [[ -z "${target}" ]]; then
  exit 1
fi

case "${target}" in
  "access.gas-x.de")
    ssh -i ~/.ssh/id_ed25519_gasx ipetrov@access.gas-x.de
    ;;
  "ip812")
    while read -r instance_id; do
        aws ssm start-session \
            --target ${instance_id} \
            --region eu-central-1 \
            --document-name AWS-StartInteractiveCommand \
            --parameters '{"command": ["tmux attach-session -t default || tmux new-session -s default"]}' >/dev/tty 2>/dev/tty </dev/tty
    done < <(aws ec2 describe-instances \
            --region eu-central-1 \
            --filters "Name=tag:Environment,Values=prod" "Name=tag:Organization,Values=ip812" "Name=instance-state-name,Values=running" \
            --query "Reservations[].Instances[].InstanceId" \
            --output json | jq -r '.[]' | head -n 1)
    ;;
  *)
    echo "Something went wrong" >&2
    ;;
esac

