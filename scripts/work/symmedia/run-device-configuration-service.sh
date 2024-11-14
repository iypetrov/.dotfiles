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
# device-status-service
boundary connect -target-id ttcp_XPwajKdMYV -listen-port 8785 & \

export SERVICE_NAME="deviceconfiguration"
export DB_URL="jdbc:sqlserver://sql-server-common-dev.database.windows.net:1433;database=sqldb-deviceconfigurationservice-dev;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;"
export DB_DRIVER_CLASSNAME="com.microsoft.sqlserver.jdbc.SQLServerDriver"

export SPRING_DATASOURCE_USERNAME=$(az_key sqldb-deviceconfigurationservice-username)
export SPRING_DATASOURCE_PASSWORD=$(az_key sqldb-deviceconfigurationservice-password)
export IOT_HUB_ACCESS_KEY_NAME=$(az_key deviceconfigurationservice-iothub-sa-key)
export SB_CONNECTION_ACCESS_KEY=$(az_key sbt-domain-events-auth)
export EVENT_STORAGE_CONNECTION_STRING=$(az_key domain-event-storage-connection)
export NEXUS_TOKEN=$(az_key nexus-edgedevice-images-accesstoken)
export APOLLO_KEY=$(az_key apollo-key)

mvn clean spring-boot:run -Dspring-boot.run.profiles=prod -Dspring.output.ansi.enabled=always \
  -DSERVICE_NAME="$SERVICE_NAME" \
  -DDB_URL="$DB_URL" \
  -DDB_DRIVER_CLASSNAME="$DB_DRIVER_CLASSNAME" \
  -DSPRING_DATASOURCE_USERNAME="$SPRING_DATASOURCE_USERNAME" \
  -DSPRING_DATASOURCE_PASSWORD="$SPRING_DATASOURCE_PASSWORD" \
  -DIOT_HUB_ACCESS_KEY_NAME="$IOT_HUB_ACCESS_KEY_NAME" \
  -DSB_CONNECTION_ACCESS_KEY="$SB_CONNECTION_ACCESS_KEY" \
  -DEVENT_STORAGE_CONNECTION_STRING="$EVENT_STORAGE_CONNECTION_STRING" \
  -DNEXUS_TOKEN="$NEXUS_TOKEN" \
  -DAPOLLO_KEY="$APOLLO_KEY"
