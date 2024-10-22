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
boundary connect -target-id ttcp_LN4jUBrqlE -listen-port 8095 & \
# device-provisioning-service
boundary connect -target-id ttcp_grpVe95qHg -listen-port 8093 & \

export DB_DRIVER_CLASSNAME="com.microsoft.sqlserver.jdbc.SQLServerDriver"
export DB_URL="jdbc:sqlserver://sql-server-common-dev.database.windows.net:1433;database=sqldb-filetransferservice-dev;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;"
export STORAGE_ACCOUNT_NAME="stfiletransfersvcdev"
export STORAGE_ENDPOINT="https://stfiletransfersvcdev.blob.core.windows.net/filetransfer-container-dev"
export STORAGE_CONTAINER="filetransfer-container-dev"
export DOWNLOAD_SERVICE_URL="https://filetransfer-development.secure-service-hub.de/download/"
export AUDIENCE="5d054d41-3f2a-4856-9cdc-9ad91a43e152"
export ISSUER="https://symmediaplatformdev.b2clogin.com/5df3c350-4552-4960-94da-06bb744ad906/v2.0/"
export PROVIDER_URL="https://symmediaplatformdev.b2clogin.com/symmediaplatformdev.onmicrosoft.com/b2c_1a_signin/discovery/v2.0/keys"
export DEVICE_PROVISIONING_SERVICE_ENDPOINT="http://device-provisioning-service.device-provisioning-service.svc.cluster.local/graphql"
export SB_DOMAIN_EVENT_TOPIC_NAME="sbt-domain-events"
export SB_DOMAIN_EVENT_SUBSCRIPTION_NAME="sbs-file-transfer-service"

export IOT_HUB_ACCESS_KEY_NAME=$(az_key filetransferservice-iothub-sa-key)
export STORAGE_ACCOUNT_KEY=$(az_key filetransferservice-storage-account-key)
export SPRING_DATASOURCE_USERNAME=$(az_key sqldb-filetransferservice-username)
export SPRING_DATASOURCE_PASSWORD=$(az_key sqldb-filetransferservice-password)
export AES_PASSWORD=$(az_key filetransferservice-aes-password)
export AES_SALT=$(az_key filetransferservice-aes-salt)
export EVENT_HUB_ACCESS_KEY_NAME=$(az_key filetransferservice-eventhub-sa-key)
export SB_CONNECTION_ACCESS_KEY=$(az_key sbn-filetransferserviceaccesskey)

mvn clean spring-boot:run -Dspring-boot.run.profiles=prod -Dspring.output.ansi.enabled=always \
  -DDB_DRIVER_CLASSNAME="$DB_DRIVER_CLASSNAME" \
  -DDB_URL="$DB_URL" \
  -DSTORAGE_ACCOUNT_NAME="$STORAGE_ACCOUNT_NAME" \
  -DSTORAGE_ENDPOINT="$STORAGE_ENDPOINT" \
  -DSTORAGE_CONTAINER="$STORAGE_CONTAINER" \
  -DDOWNLOAD_SERVICE_URL="$DOWNLOAD_SERVICE_URL" \
  -DAUDIENCE="$AUDIENCE" \
  -DISSUER="$ISSUER" \
  -DPROVIDER_URL="$PROVIDER_URL" \
  -DDEVICE_PROVISIONING_SERVICE_ENDPOINT="$DEVICE_PROVISIONING_SERVICE_ENDPOINT" \
  -DSB_DOMAIN_EVENT_TOPIC_NAME="$SB_DOMAIN_EVENT_TOPIC_NAME" \
  -DSB_DOMAIN_EVENT_SUBSCRIPTION_NAME="$SB_DOMAIN_EVENT_SUBSCRIPTION_NAME" \
  -DIOT_HUB_ACCESS_KEY_NAME="$IOT_HUB_ACCESS_KEY_NAME" \
  -DSTORAGE_ACCOUNT_KEY="$STORAGE_ACCOUNT_KEY" \
  -DSPRING_DATASOURCE_USERNAME="$SPRING_DATASOURCE_USERNAME" \
  -DSPRING_DATASOURCE_PASSWORD="$SPRING_DATASOURCE_PASSWORD" \
  -DAES_PASSWORD="$AES_PASSWORD" \
  -DAES_SALT="$AES_SALT" \
  -DEVENT_HUB_ACCESS_KEY_NAME="$EVENT_HUB_ACCESS_KEY_NAME" \
  -DSB_CONNECTION_ACCESS_KEY="$SB_CONNECTION_ACCESS_KEY"
