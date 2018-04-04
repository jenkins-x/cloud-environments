#!/usr/bin/env bash
set -e
set -x

gcloud auth activate-service-account --key-file $SERVICE_ACCOUNT_FILE

jx create cluster gke -n ${CLUSTER_NAME,,}-${BUILD_NUMBER} \
    --skip-login=true \
    --batch-mode \
    --labels kind=bdd,git=ghe \
    --project-id ${PROJECT_ID} \
    --zone ${ZONE} \
    --machine-type n1-standard-2 \
    --num-nodes 2 \
    --git-username $GH_CREDS_USR \
    --git-api-token $GH_CREDS_PSW \
    --default-admin-password $TEST_PASSWORD \
    --git-provider-url ${GIT_PROVIDER_URL} \
    --local-cloud-environment=true \
    --default-environment-prefix=b${BUILD_NUMBER} \
    --environment-git-owner=jenkins-x-tests \
    --default-environments=false

jx namespace jx