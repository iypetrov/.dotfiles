#!/bin/bash

[[ ! $(command -v fzf) ]] && echo "Error: You need to have fzf installed" >&2 && return 1
[[ ! $(command -v kubectx) ]] && echo "Error: You need to have kubectx installed" >&2 && return 1
[[ ! $(command -v k9s) ]] && echo "Error: You need to have k9s installed" >&2 && return 1

target="$(echo "connect kubectx kubens k9s" | tr ' ' '\n' | fzf)"
if [[ -z "${target}" ]]; then
  exit 1
fi

case "${target}" in
  "connect")
    ENVIRONMENT="$(echo "dev test perf staging prod tools" | tr ' ' '\n' | fzf)"
    case "$ENVIRONMENT" in
      dev | development)
        TARGET_NAME="K8s API server (Dev)"
        CLUSTER_NAME="k8s-symmedia-apps-dev"
        CLUSTER_SUBSCRIPTION="sym-cloudplatform-dev"
        CLUSTER_RESOURCE_GROUP="rg-plat-kubernetes-dev"
        BOUNDARY_TARGET_ID="ttcp_fWLXN1L5z6"
        ;;
      test)
        TARGET_NAME="K8s API server (Test)"
        CLUSTER_NAME="k8s-symmedia-apps-test"
        CLUSTER_SUBSCRIPTION="sym-cloudplatform-test"
        CLUSTER_RESOURCE_GROUP="rg-plat-kubernetes-test"
        BOUNDARY_TARGET_ID="ttcp_UtoNmMexqI"
        ;;
      perf | performance)
        TARGET_NAME="K8s API server (Perf)"
        CLUSTER_NAME="k8s-symmedia-apps-perf"
        CLUSTER_SUBSCRIPTION="sym-cloudplatform-performance"
        CLUSTER_RESOURCE_GROUP="rg-plat-kubernetes-perf"
        BOUNDARY_TARGET_ID="ttcp_1nO4HOWdHH"
        ;;
      staging)
        TARGET_NAME="K8s API server (Staging)"
        CLUSTER_NAME="k8s-symmedia-apps-staging"
        CLUSTER_SUBSCRIPTION="sym-cloudplatform-dev"
        CLUSTER_RESOURCE_GROUP="rg-plat-kubernetes-staging"
        BOUNDARY_TARGET_ID="ttcp_RoBrrLQHG9"
        ;;
      prod | production)
        TARGET_NAME="K8s API server (Prod)"
        CLUSTER_NAME="k8s-symmedia-apps-prod"
        CLUSTER_SUBSCRIPTION="sym-cloudplatform-prod"
        CLUSTER_RESOURCE_GROUP="rg-plat-kubernetes-prod"
        ;;
      tools)
        TARGET_NAME="K8s API server (Tools)"
        CLUSTER_NAME="k8s-tools"
        CLUSTER_SUBSCRIPTION="sym-cloudplatform-common"
        CLUSTER_RESOURCE_GROUP="rg-k8s-tools"
        ;;
      *)
        echo "Usage: ./boundary-k8s-login.sh <dev|test|perf|staging|prod|tools>" >&2
        exit 1
        ;;
    esac

  # Step 2: Get client port from Boundary
  TARGET_ID=$(boundary targets list -recursive -filter '"/item/name" == "'"$TARGET_NAME"'" and "authorize-session" in "/item/authorized_actions" and "/item/scope/type" == "project"' -format json | jq -r 'if .items != null then .items[0].id else empty end')
  [[ -z "$TARGET_ID" ]] && echo "Error: Could not find target \"$TARGET_NAME\"" >&2 && exit 1
  CLIENT_PORT=$(boundary targets read -id "$TARGET_ID" -format json | jq -r '.item.attributes.default_client_port')
  [[ $CLIENT_PORT =~ ^[0-9]+$ ]] || { echo "Error: Could not get client port from target" >&2 && exit 1; }

  # Step 3: Get host address from Boundary
  HOST_SET_ID=$(boundary targets read -id "$TARGET_ID" -format json | jq -r '.item.host_sources[0].id')
  [[ -z "$HOST_SET_ID" ]] && echo "Error: Could not get host set ID from target" >&2 && exit 1
  HOST_ID=$(boundary host-sets read -id "$HOST_SET_ID" -format json | jq -r '.item.host_ids[0]')
  [[ -z "$HOST_ID" ]] && echo "Error: Could not get host ID from host set" >&2 && exit 1
  HOST_ADDRESS=$(boundary hosts read -id "$HOST_ID" -format json | jq -r '.item.attributes.address')
  [[ -z "$HOST_ADDRESS" ]] && echo "Error: Could not get host address from host" >&2 && exit 1

  # Step 4: Get AKS credentials for the target cluster
  # Automatically switches to the correct kubectl context too
  az aks get-credentials --subscription "$CLUSTER_SUBSCRIPTION" --resource-group "$CLUSTER_RESOURCE_GROUP" --name "$CLUSTER_NAME" --overwrite-existing

  # Step 5: Set kubeconfig to use the Boundary tunnel
  kubectl config set "clusters.${CLUSTER_NAME}.server" "https://127.0.0.1:$CLIENT_PORT"
  kubectl config set "clusters.${CLUSTER_NAME}.tls-server-name" "$HOST_ADDRESS"

  # Step 6: Start the Boundary client
  boundary connect -target-id "${BOUNDARY_TARGET_ID}" 
  ;;
"kubectx")
  kubectx 
  ;;
"kubens")
  kubens 
  ;;
"k9s")
  k9s
  ;;
*)
  echo "Something went wrong" >&2
  ;;
esac
