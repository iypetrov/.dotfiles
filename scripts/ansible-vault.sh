#!/bin/bash

action="$(echo "encrypt decrypt" | tr ' ' '\n' | fzf)"

if [[ "$action" == "encrypt" ]];then
    ansible-vault encrypt --ask-vault-pass ~/auth_codes/*.txt ~/.ssh/id_rsa
elif [[ "$action" == "decrypt" ]];then
    ansible-vault decrypt --ask-vault-pass ~/auth_codes/*.txt ~/.ssh/id_rsa
fi
