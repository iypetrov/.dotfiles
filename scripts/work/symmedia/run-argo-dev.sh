#!/bin/bash

USER_ID="u_Uq6acX62iM"
boundary sessions list -format "json" -recursive -filter='"/item/user_id" == "'"$USER_ID"'"' | jq -r 'if .items != null then .items[].id else empty end' | xargs -I {} boundary sessions cancel -id {}

boundary connect -target-id ttcp_3KvICN1Eze -listen-port 8080
