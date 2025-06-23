#!/bin/bash

[[ ! $(command -v fzf) ]] && echo "Error: You need to have fzf installed" >&2 && return 1

target="$(echo "infra003 ip812 ip812-1 aws" | tr ' ' '\n' | fzf --tac)"
if [[ -z "${target}" ]]; then
  exit 1
fi

case "${target}" in
  "infra003")
    ssh -i ~/.ssh/id_ed25519_work ipetrov@infra003.gas-x.de
    ;;
  "ip812")
    ssh root@ip812-prod-k8s-node
    ;;
  "ip812-1")
    ssh root@ip812-prod-k8s-node-1
    ;;
  "aws")
   instance_id=$(
      aws ec2 describe-instances \
        --region eu-central-1 \
        --query "Reservations[].Instances[?State.Name=='running'].[InstanceId, Tags[?Key=='Name']|[0].Value, State.Name]" \
        --output text | \
      fzf --tac | \
      awk '{print $1}'
    )
 
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
