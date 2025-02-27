#!/bin/bash

[[ ! $(command -v fzf) ]] && echo "Error: You need to have fzf installed" >&2 && return 1

target="$(echo "access.gas-x.de de-gasx-aws de-lab12 de-lab52 ip812" | tr ' ' '\n' | fzf --tac)"
if [[ -z "${target}" ]]; then
  exit 1
fi

case "${target}" in
  "access.gas-x.de")
    ssh -i ~/.ssh/id_ed25519_gasx ipetrov@access.gas-x.de
    ;;
  "de-gasx-aws")
    instance_id=$(aws ec2 describe-instances \
            --region eu-central-1 \
            --filters "Name=instance-state-name,Values=running" \
            --query "Reservations[].Instances[].InstanceId" \
            --output json \
            --profile 034013843855_ipgx-infra-integration | \
            jq -r '.[]' | fzf --tac)

    aws ssm start-session \
        --target "${instance_id}" \
        --region eu-central-1 \
        --profile 034013843855_ipgx-infra-integration
    ;;
  "de-lab12")
    instance_id=$(aws ec2 describe-instances \
            --region eu-central-1 \
            --filters "Name=instance-state-name,Values=running" \
            --query "Reservations[].Instances[].InstanceId" \
            --output json \
            --profile 903999197368_ipgx-infra-acceptance | \
            jq -r '.[]' | fzf --tac)

    aws ssm start-session \
        --target "${instance_id}" \
        --region eu-central-1 \
        --profile 903999197368_ipgx-infra-acceptance
    ;;
  "de-lab52")
    instance_id=$(aws ec2 describe-instances \
            --region eu-central-1 \
            --filters "Name=instance-state-name,Values=running" \
            --query "Reservations[].Instances[].InstanceId" \
            --output json \
            --profile 833704146350_ipgx-infra-rnd | \
            jq -r '.[]' | fzf --tac)

    aws ssm start-session \
        --target "${instance_id}" \
        --region eu-central-1 \
        --profile 833704146350_ipgx-infra-rnd
    ;;
  "ip812")
    instance_id=$(aws ec2 describe-instances \
            --region eu-central-1 \
            --filters "Name=instance-state-name,Values=running" \
            --query "Reservations[].Instances[].InstanceId" \
            --output json | jq -r '.[]' | fzf --tac)

    aws ssm start-session \
        --target ${instance_id} \
        --region eu-central-1 \
        --document-name AWS-StartInteractiveCommand \
        --parameters '{"command": ["tmux attach-session -t default || tmux new-session -s default"]}' >/dev/tty 2>/dev/tty </dev/tty
    ;;
  *)
    echo "Something went wrong" >&2
    ;;
esac

