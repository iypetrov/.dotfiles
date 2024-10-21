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

export DB_URL="jdbc:sqlserver://sql-server-common-dev.database.windows.net:1433;database=sqldb-certificatemanagement-dev;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;"
export DB_DRIVER_CLASSNAME="com.microsoft.sqlserver.jdbc.SQLServerDriver"
export KEY_VAULT_TENANT_ID="71660f62-ed66-46b1-a9a6-59e052075879"
export KEY_VAULT_URL="https://kv-iothub-dev1.vault.azure.net/"
export KEY_VAULT_CLIENT_ID="a35d70cc-5e11-4d37-bf90-fa53ed8bfaf8"
export KEY_VAULT_ROOT_CA_URL="https://kv-sym-plat-root-ca.vault.azure.net/"
export KEY_VAULT_USE_HSM="false"
export KEY_VAULT_ENVIRONMENT="dev-staging"
export PERMISSION_SERVICE_ENDPOINT="http://accessmanagementservice.accessmanagement.svc.cluster.local/graphql"
export KEY_VAULT_K8S_URL="https://kv-k8s-apps-dev.vault.azure.net/"
export ELASTIC_APM_TRACE_METHODS="public @com.netflix.graphql.dgs.DgsDataLoader de.symmedia.edge.core.*, public @org.springframework.stereotype.Service de.symmedia.*, @org.axonframework.spring.stereotype.Aggregate de.symmedia.*#handle, @org.axonframework.spring.stereotype.Aggregate de.symmedia.*#on, public @org.springframework.stereotype.Component de.symmedia.*.*ServiceClient"
export VAULT_URL="https://vault-development.secure-service-hub.com"
export SSC_VPN_SECRET_ENGINE_PATH="symmedia/ssc_vpn/v1"
export SSC_VPN_SERVER_SECRET_ENGINE_ROLE="ssc-vpn-ica-server-dev" 
export SSC_VPN_CLIENT_SECRET_ENGINE_ROLE="ssc-vpn-ica-client-dev" 
export PORTUNIFICATION_SECRET_ENGINE_PATH="symmedia/ssh/v1"
export PORTUNIFICATION_SERVER_SECRET_ENGINE_ROLE="symmedia-portunification-dev-ica" 
export PORTUNIFICATION_VAULT_ENABLED="true"
export SSC_VPN_SECRET_ENGINE_TOKEN_FILE="/vault/secrets/token"
export PORTUNIFICATION_SECRET_ENGINE_TOKEN_FILE="/vault/secrets/token"

export SPRING_DATASOURCE_USERNAME=$(az_key sqldb-certificatemanagement-username)
export SPRING_DATASOURCE_PASSWORD=$(az_key sqldb-certificatemanagement-password)
export KEY_VAULT_CLIENT_SECRET=$(az_key certificatemgmtservice-kv-client-secret)
export KEY_VAULT_CLIENT_ID=$(az_key certificatemgmtservice-kv-client-id)
export SB_CONNECTION_ACCESS_KEY=$(az_key sbn-certificatemanagementserviceaccesskey)
export EVENT_STORAGE_CONNECTION_STRING=$(az_key domain-event-storage-connection)

mvn clean spring-boot:run -Dspring-boot.run.profiles=prod -Dspring.output.ansi.enabled=always \
  -DSERVICE_NAME="$SERVICE_NAME" \
  -DDB_URL="$DB_URL" \
  -DDB_DRIVER_CLASSNAME="$DB_DRIVER_CLASSNAME" \
  -DSPRING_DATASOURCE_USERNAME="$SPRING_DATASOURCE_USERNAME" \
  -DSPRING_DATASOURCE_PASSWORD="$SPRING_DATASOURCE_PASSWORD" \
  -DKEY_VAULT_CLIENT_SECRET="$KEY_VAULT_CLIENT_SECRET" \
  -DKEY_VAULT_CLIENT_ID="$KEY_VAULT_CLIENT_ID" \
  -DSB_CONNECTION_ACCESS_KEY="$SB_CONNECTION_ACCESS_KEY" \
  -DEVENT_STORAGE_CONNECTION_STRING="$EVENT_STORAGE_CONNECTION_STRING" \
  -DKEY_VAULT_TENANT_ID="$KEY_VAULT_TENANT_ID" \
  -DKEY_VAULT_URL="$KEY_VAULT_URL" \
  -DKEY_VAULT_ROOT_CA_URL="$KEY_VAULT_ROOT_CA_URL" \
  -DKEY_VAULT_USE_HSM="$KEY_VAULT_USE_HSM" \
  -DKEY_VAULT_ENVIRONMENT="$KEY_VAULT_ENVIRONMENT" \
  -DPERMISSION_SERVICE_ENDPOINT="$PERMISSION_SERVICE_ENDPOINT" \
  -DKEY_VAULT_K8S_URL="$KEY_VAULT_K8S_URL" \
  -DELASTIC_APM_TRACE_METHODS="$ELASTIC_APM_TRACE_METHODS" \
  -DVAULT_URL="$VAULT_URL" \
  -DSSC_VPN_SECRET_ENGINE_PATH="$SSC_VPN_SECRET_ENGINE_PATH" \
  -DSSC_VPN_SERVER_SECRET_ENGINE_ROLE="$SSC_VPN_SERVER_SECRET_ENGINE_ROLE" \
  -DSSC_VPN_CLIENT_SECRET_ENGINE_ROLE="$SSC_VPN_CLIENT_SECRET_ENGINE_ROLE" \
  -DPORTUNIFICATION_SECRET_ENGINE_PATH="$PORTUNIFICATION_SECRET_ENGINE_PATH" \
  -DPORTUNIFICATION_SERVER_SECRET_ENGINE_ROLE="$PORTUNIFICATION_SERVER_SECRET_ENGINE_ROLE" \
  -DPORTUNIFICATION_VAULT_ENABLED="$PORTUNIFICATION_VAULT_ENABLED" \
  -DSSC_VPN_SECRET_ENGINE_TOKEN_FILE="$SSC_VPN_SECRET_ENGINE_TOKEN_FILE" \
  -DPORTUNIFICATION_SECRET_ENGINE_TOKEN_FILE="$PORTUNIFICATION_SECRET_ENGINE_TOKEN_FILE"
