pipeline {
    agent any
    environment {
        GKE_SA = credentials('gke-sa')
        GH_CREDS = credentials('jx-pipeline-git-github-github')
        GHE_CREDS = credentials('jx-pipeline-git-github-ghe')
        JENKINS_CREDS = credentials('test-jenkins-user')
        GIT_PROVIDER_URL = "https://github.beescloud.com"
    }
    stages {
        stage('CI Build') {
            when {
                branch 'PR-*'
            }
            environment {
                CLUSTER_NAME = "JXCE-$BRANCH_NAME-$BUILD_NUMBER"
                ZONE = "europe-west1-c"
                PROJECT_ID = "jenkinsx-dev"
                SERVICE_ACCOUNT_FILE = "$GKE_SA"
                GHE_TOKEN = "$GHE_CREDS_PSW"
                JENKINS_PASSWORD="$JENKINS_CREDS_PSW"

                JX_DISABLE_DELETE_APP  = "true"
                JX_DISABLE_DELETE_REPO = "true"

                // enable debug logging
                GINKGO_ARGS            = "-v"

                // lets use a separate cluster
                JX_HOME="/tmp/jxhome"
                KUBECONFIG="/tmp/jxhome/config"
            }
            steps {
                sh "./jx/scripts/bdd.sh"
            }
        }

        stage('Build and Push Release') {
            when {
                branch 'master'
            }
            steps {
                // auto upgrade demo env
                echo 'auto upgrades not yet implemented'
            }
        }
    }
}
