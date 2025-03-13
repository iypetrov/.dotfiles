#!/bin/bash

[[ ! $(command -v fzf) ]] && echo "Error: You need to have fzf installed" >&2 && return 1

target="$(echo "access.gas-x.de de-gasx-aws de-lab12 de-lab52 de-lab09 ip812" | tr ' ' '\n' | fzf --tac)"
if [[ -z "${target}" ]]; then
  exit 1
fi

case "${target}" in
  "access.gas-x.de")
    ssh -i ~/.ssh/id_ed25519_gasx ipetrov@access.gas-x.de
    ;;
  "de-gasx-aws")
    acc="de_gasx"
    echo "${acc}" > ~/.aws/current_acc
    instance_id=$(aws ec2 describe-instances \
        --region eu-central-1 \
        --filters "Name=instance-state-name,Values=running" \
        --query "Reservations[].Instances[].{ID: Instances[].InstanceId, Name: Instances[].Tags[?Key=='Name'].Value | [0]}" \
        --output json \
        --profile de_gasx | \
        jq -r '.[] | .Name[0] + " " + .ID[0]' | fzf --tac | awk '{print $2}')

    aws ssm start-session \
        --target "${instance_id}" \
        --region eu-central-1 \
        --profile 034013843855_ipgx-infra-integration
    ;;
  "de-lab12")
    acc="de_lab12"
    echo "${acc}" > ~/.aws/current_acc
    instance_id=$(aws ec2 describe-instances \
            --region eu-central-1 \
            --filters "Name=instance-state-name,Values=running" \
            --query "Reservations[].Instances[].InstanceId" \
            --output json \
            --profile de_lab12 | \
            jq -r '.[]' | fzf --tac)

    aws ssm start-session \
        --target "${instance_id}" \
        --region eu-central-1 \
        --profile 903999197368_ipgx-infra-acceptance
    ;;
  "de-lab52")
    acc="de_lab52"
    echo "${acc}" > ~/.aws/current_acc
    instance_id=$(aws ec2 describe-instances \
            --region eu-central-1 \
            --filters "Name=instance-state-name,Values=running" \
            --query "Reservations[].Instances[].InstanceId" \
            --output json \
            --profile de_lab52 | \
            jq -r '.[]' | fzf --tac)

    aws ssm start-session \
        --target "${instance_id}" \
        --region eu-central-1 \
        --profile 833704146350_ipgx-infra-rnd
    ;;
  "de-lab09")
    acc="de_lab09"
    echo "${acc}" > ~/.aws/current_acc
    instance_id=$(aws ec2 describe-instances \
            --region eu-central-1 \
            --filters "Name=instance-state-name,Values=running" \
            --query "Reservations[].Instances[].InstanceId" \
            --output json \
            --profile de_lab09 | \
            jq -r '.[]' | fzf --tac)

    aws ssm start-session \
        --target "${instance_id}" \
        --region eu-central-1 \
        --profile 833704146350_ipgx-infra-rnd
    ;;
  "ip812")
    acc="personal"
    echo "${acc}" > ~/.aws/current_acc
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

