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

USER_ID="u_Uq6acX62iM"; boundary sessions list -format "json" -recursive -filter='"/item/user_id" == "'"$USER_ID"'"' | jq -r 'if .items != null then .items[].id else empty end' | xargs -I {} boundary sessions cancel -id {}

# access-management-service
boundary connect -target-id ttcp_UQc4bK4AAW -listen-port 8091 & \
# certificate-management-service
boundary connect -target-id ttcp_NCC0jaUZgN -listen-port 8092 & \
# tenant-service
boundary connect -target-id ttcp_Ku2RHMRN48 -listen-port 8094 & \
# machine-service
boundary connect -target-id ttcp_LN4jUBrqlE -listen-port 8095 & \
# device-configuration-service
boundary connect -target-id ttcp_PGj0fIUhQl -listen-port 8096 & \

export DB_URL="jdbc:sqlserver://sql-server-common-dev.database.windows.net:1433;database=sqldb-deviceprovisioningservice-dev;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;"
export DB_DRIVER_CLASSNAME="com.microsoft.sqlserver.jdbc.SQLServerDriver"
export SB_DOMAIN_EVENT_TOPIC_NAME="sbt-domain-events"
export SB_DOMAIN_EVENT_SUBSCRIPTION_NAME="sbs-deviceprovision-service"
export LINKED_IOT_HUB="iothub-sym-dev.azure-devices.net"
export DE_SYMMEDIA_AZURE_EVENT_STORAGE_MAX_RETRY="30"
export DEPLOYFUNC_SB_RESPONSE_SUBSCRIPTION_PATH="sbt-deployment-function-commands/subscriptions/sbs-deployment-response"
export DEPLOYFUNC_SB_TOPIC_NAME="sbt-deployment-function-commands"
export DEPLOYFUNC_SB_DEPOLY_DEFAULT_TO_FILTER="default-deployment-manifest"
export DEPLOYFUNC_SB_INITIALIZE_TO_FILTER="initialize-deployment-manifest"
export DEPLOYFUNC_SB_CHANGE_EDGE_DEVICE_LINKING_TO_FILTER="change-edge-device-linking"

export SPRING_DATASOURCE_USERNAME=$(az_key sqldb-deviceprovisioningservice-username)
export SPRING_DATASOURCE_PASSWORD=$(az_key sqldb-deviceprovisioningservice-password)
export DPS_ACCESS_KEY=$(az_key dps-deviceprovisioningservice-auth)
export IOT_HUB_DEV_ACCESS_KEY_NAME=$(az_key deviceprovisioningservice-iothub-dev-sa-key)
export IOT_HUB_TEST_ACCESS_KEY_NAME=$(az_key deviceprovisioningservice-iothub-test-sa-key)
export IOT_HUB_STAGING_ACCESS_KEY_NAME=$(az_key deviceprovisioningservice-iothub-staging-sa-key)
export SB_CONNECTION_ACCESS_KEY=$(az_key sbn-deviceprovisioningserviceaccesskey)
export EVENT_STORAGE_CONNECTION_STRING=$(az_key domain-event-storage-connection)
export DEPLOYFUNC_SB_CONNECTION_STRING=$(az_key sbt-deployment-function-commands-auth)

mvn clean spring-boot:run -Dspring-boot.run.profiles=local -Dspring.output.ansi.enabled=always \
  -DDB_URL="$DB_URL" \
  -DDB_DRIVER_CLASSNAME="$DB_DRIVER_CLASSNAME" \
  -DSB_DOMAIN_EVENT_TOPIC_NAME="$SB_DOMAIN_EVENT_TOPIC_NAME" \
  -DSB_DOMAIN_EVENT_SUBSCRIPTION_NAME="$SB_DOMAIN_EVENT_SUBSCRIPTION_NAME" \
  -DLINKED_IOT_HUB="$LINKED_IOT_HUB" \
  -DPERMISSION_SERVICE_ENDPOINT="$PERMISSION_SERVICE_ENDPOINT" \
  -DCERTIFICATE_SERVICE_ENDPOINT="$CERTIFICATE_SERVICE_ENDPOINT" \
  -DTENANT_SERVICE_ENDPOINT="$TENANT_SERVICE_ENDPOINT" \
  -DMACHINE_SERVICE_ENDPOINT="$MACHINE_SERVICE_ENDPOINT" \
  -DDEVICECONFIGURATION_SERVICE_ENDPOINT="$DEVICECONFIGURATION_SERVICE_ENDPOINT" \
  -DDE_SYMMEDIA_AZURE_EVENT_STORAGE_MAX_RETRY="$DE_SYMMEDIA_AZURE_EVENT_STORAGE_MAX_RETRY" \
  -DEPLOYFUNC_SB_RESPONSE_SUBSCRIPTION_PATH="$DEPLOYFUNC_SB_RESPONSE_SUBSCRIPTION_PATH" \
  -DEPLOYFUNC_SB_TOPIC_NAME="$DEPLOYFUNC_SB_TOPIC_NAME" \
  -DEPLOYFUNC_SB_DEPOLY_DEFAULT_TO_FILTER="$DEPLOYFUNC_SB_DEPOLY_DEFAULT_TO_FILTER" \
  -DEPLOYFUNC_SB_INITIALIZE_TO_FILTER="$DEPLOYFUNC_SB_INITIALIZE_TO_FILTER" \
  -DEPLOYFUNC_SB_CHANGE_EDGE_DEVICE_LINKING_TO_FILTER="$DEPLOYFUNC_SB_CHANGE_EDGE_DEVICE_LINKING_TO_FILTER" \
  -DSPRING_DATASOURCE_USERNAME="$SPRING_DATASOURCE_USERNAME" \
  -DSPRING_DATASOURCE_PASSWORD="$SPRING_DATASOURCE_PASSWORD" \
  -DDPS_ACCESS_KEY="$DPS_ACCESS_KEY" \
  -DIOT_HUB_DEV_ACCESS_KEY_NAME="$IOT_HUB_DEV_ACCESS_KEY_NAME" \
  -DIOT_HUB_TEST_ACCESS_KEY_NAME="$IOT_HUB_TEST_ACCESS_KEY_NAME" \
  -DIOT_HUB_STAGING_ACCESS_KEY_NAME="$IOT_HUB_STAGING_ACCESS_KEY_NAME" \
  -DSB_CONNECTION_ACCESS_KEY="$SB_CONNECTION_ACCESS_KEY" \
  -DEVENT_STORAGE_CONNECTION_STRING="$EVENT_STORAGE_CONNECTION_STRING" \
  -DEPLOYFUNC_SB_CONNECTION_STRING="$DEPLOYFUNC_SB_CONNECTION_STRING"
