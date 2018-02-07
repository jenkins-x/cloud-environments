#!/usr/bin/env bash
set -e
set -x

gcloud auth activate-service-account --key-file $SERVICE_ACCOUNT_FILE

# jx create cluster gke -n ${CLUSTER_NAME,,} \
#     --skip-login=true \
#     --batch-mode \
#     --project-id ${PROJECT_ID} \
#     --zone ${ZONE} \
#     --machine-type n1-standard-2 \
#     --num-nodes 2 \
#     --git-username $GH_CREDS_USR \
#     --git-api-token $GH_CREDS_PSW \
#     --git-provider-url github.com

# lets reuse the existing cluster to test running the BDD tests
gcloud container clusters get-credentials jxce-pr-50 --zone europe-west1-b --project jenkinsx-dev

jx namespace jx  
# lets ensure there's a jenkins API token so we can add projects  
# jx create jenkins user  --password admin admin
