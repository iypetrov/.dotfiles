#!/bin/bash

[[ ! $(command -v fzf) ]] && echo "Error: You need to have fzf installed" >&2 && return 1

target="$(echo "access.gas-x.de aws" | tr ' ' '\n' | fzf --tac)"
if [[ -z "${target}" ]]; then
  exit 1
fi

case "${target}" in
  "access.gas-x.de")
    ssh -i ~/.ssh/id_ed25519_gasx ipetrov@access.gas-x.de
    ;;
  "aws")
    instance_id=$(aws ec2 describe-instances \
        --region eu-central-1 \
        --query "Reservations[].Instances[]" \
        --output json | \
        jq -r '.[] | select(.State.Name == "running") | .InstanceId + " " + (.Tags[] | select(.Key == "Name") | .Value)' | \
        while read -r id name state; do
            status_check=$(aws ec2 describe-instance-status --instance-ids "$id" --region eu-central-1 \
                --query "InstanceStatuses[].InstanceStatus.Status" --output text)
            echo "$id $name $state $status_check"
        done | \
        fzf --tac | \
        awk '{print $1}')
    
    if [ -n "$instance_id" ]; then
        aws ssm start-session \
            --target "${instance_id}" \
            --region eu-central-1
    fi
# aws ssm start-session \
    #     --target ${instance_id} \
    #     --region eu-central-1 \
    #     --document-name AWS-StartInteractiveCommand \
    #     --parameters '{"command": ["tmux attach-session -t default || tmux new-session -s default"]}' >/dev/tty 2>/dev/tty </dev/tty
    ;;
  *)
    echo "Something went wrong" >&2
    ;;
esac

