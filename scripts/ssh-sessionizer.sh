#!/bin/bash

[[ ! $(command -v fzf) ]] && echo "Error: You need to have fzf installed" >&2 && return 1

target="$(echo "sym-VM-eba7723976c1 sym-VM-904cc0fa0741 ip812" | tr ' ' '\n' | fzf --tac)"
if [[ -z "${target}" ]]; then
  exit 1
fi

type="$(echo "default tmux" | tr ' ' '\n' | fzf --tac)"
if [[ -z "${type}" ]]; then
  exit 1
fi

case "${target}" in
  "sym-VM-eba7723976c1")
    if [[ "${type}" == "default" ]]; then
      ssh digital@192.168.0.242
    elif [[ "${type}" == "tmux" ]]; then
      ssh digital@192.168.0.242 -t 'tmux attach-session -t default || tmux new-session -s default'
    fi
    ;;
  "sym-VM-904cc0fa0741")
    if [[ "${type}" == "default" ]]; then
      ssh digital@127.0.0.1 -p 1035
    elif [[ "${type}" == "tmux" ]]; then
      ssh digital@127.0.0.1 -p 1035 -t 'tmux attach-session -t default || tmux new-session -s default'
    fi
    ;;
  "ip812")
    if [[ "${type}" == "default" ]]; then
        while read -r instance_id; do
            unbuffer aws ssm start-session --target ${instance_id} --region eu-central-1
        done < <(aws ec2 describe-instances \
            --region eu-central-1 \
            --filters "Name=tag:Environment,Values=prod" "Name=tag:Organization,Values=ip812" "Name=instance-state-name,Values=running" \
            --query "Reservations[].Instances[].InstanceId" \
            --output json | jq -r '.[]' | head -n 1)
    elif [[ "${type}" == "tmux" ]]; then
        while read -r instance_id; do
            unbuffer aws ssm start-session \
                --target ${instance_id} \
                --region eu-central-1 \
                --document-name AWS-StartInteractiveCommand \
                --parameters '{"command": ["tmux attach-session -t default || tmux new-session -s default"]}'
        done < <(aws ec2 describe-instances \
            --region eu-central-1 \
            --filters "Name=tag:Environment,Values=prod" "Name=tag:Organization,Values=ip812" "Name=instance-state-name,Values=running" \
            --query "Reservations[].Instances[].InstanceId" \
            --output json | jq -r '.[]' | head -n 1)
    fi
    ;;
  *)
    echo "Something went wrong" >&2
    ;;
esac
