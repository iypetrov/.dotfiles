#!/bin/bash

az_key() {
  if [ "$#" -ne 1 ]; then
    echo "Usage: az_key <secret-name>"
    return 1
  fi
  local secret_name="$1"
  local key_vault_name="kv-k8s-apps-dev"
  az keyvault secret show --name "${secret_name}" --vault-name "${key_vault_name}" --query value -o tsv
}

USER_ID="u_Uq6acX62iM"
boundary sessions list -format "json" -recursive -filter='"/item/user_id" == "'"$USER_ID"'"' | jq -r 'if .items != null then .items[].id else empty end' | xargs -I {} boundary sessions cancel -id {}

# access-management-service
boundary connect -target-id ttcp_UQc4bK4AAW -listen-port 8091 & \
# machine-service
boundary connect -target-id ttcp_LN4jUBrqlE -listen-port 8082 & \

export DEPLOYMENT_DB_DATABASE="DeviceStates"
export DEPLOYMENT_DB_DEPLOYMENTS_COLLECTION="Deployments"
export DEPLOYMENT_DB_REPORTED_RUNTIME_STATUS_COLLECTION="ReportedStates"
export DEPLOYMENT_DB_EDGE_DEVICE_LINKING_COLLECTION="EdgeDeviceLinking"
export DEPLOYFUNC_SB_RESPONSE_SUBSCRIPTION_PATH="sbt-deployment-function-commands/subscriptions/sbs-deployment-response"
export DEPLOYFUNC_SB_TOPIC_NAME="sbt-deployment-function-commands"
export DEPLOYFUNC_SB_BULKUPDATE_TO_FILTER="bulk-update-system-module"

export DEPLOYMENT_DB_CONNECTION=$(az_key cosmosdb-account-mongodb-connection)
export DEPLOYFUNC_SB_CONNECTION_STRING=$(az_key sbt-deployment-function-commands-auth)

mvn clean spring-boot:run -Dspring-boot.run.profiles=local -Dspring.output.ansi.enabled=always \
  -DDEPLOYMENT_DB_DATABASE="$DEPLOYMENT_DB_DATABASE" \
  -DDEPLOYMENT_DB_DEPLOYMENTS_COLLECTION="$DEPLOYMENT_DB_DEPLOYMENTS_COLLECTION" \
  -DDEPLOYMENT_DB_REPORTED_RUNTIME_STATUS_COLLECTION="$DEPLOYMENT_DB_REPORTED_RUNTIME_STATUS_COLLECTION" \
  -DDEPLOYMENT_DB_EDGE_DEVICE_LINKING_COLLECTION="$DEPLOYMENT_DB_EDGE_DEVICE_LINKING_COLLECTION" \
  -DDEPLOYFUNC_SB_RESPONSE_SUBSCRIPTION_PATH="$DEPLOYFUNC_SB_RESPONSE_SUBSCRIPTION_PATH" \
  -DDEPLOYFUNC_SB_TOPIC_NAME="$DEPLOYFUNC_SB_TOPIC_NAME" \
  -DDEPLOYFUNC_SB_BULKUPDATE_TO_FILTER="$DEPLOYFUNC_SB_BULKUPDATE_TO_FILTER" \
  -DDEPLOYMENT_DB_CONNECTION="$DEPLOYMENT_DB_CONNECTION" \
  -DDEPLOYFUNC_SB_CONNECTION_STRING="$DEPLOYFUNC_SB_CONNECTION_STRING"
