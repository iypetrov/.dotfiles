#!/bin/bash

AWS_ACCOUNT=$(cat ~/.aws/current_acc)
K8S_CLUSTER=$(kubectl config view --minify --output 'jsonpath={.contexts[0].context.cluster}')
K8S_NAMESPACE=$(kubectl config view --minify --output 'jsonpath={.contexts[0].context.namespace}')

echo "AWS: $AWS_ACCOUNT, K8s: $K8S_CLUSTER/$K8S_NAMESPACE"

