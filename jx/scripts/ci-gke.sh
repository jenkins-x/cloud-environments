#!/usr/bin/env bash
set -e
set -x

gcloud auth activate-service-account --key-file $SERVICE_ACCOUNT_FILE

jx create cluster gke -n ${CLUSTER_NAME,,} \
    --skip-login=true \
    --batch-mode \
    --project-id ${PROJECT_ID} \
    --zone ${ZONE} \
    --machine-type n1-standard-2 \
    --num-nodes 2 \
    --git-username $GH_CREDS_USR \
    --git-api-token $GH_CREDS_PSW \
    --default-admin-password $TEST_PASSWORD \
    --git-provider-url github.com \
    --local-cloud-environment=true \
    --default-environments=false

jx namespace jx