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

                // lets use a separate cluster
                JX_HOME="/tmp/jxhome"
                KUBECONFIG="/tmp/jxhome/config"
            }
            steps {
                sh "mkdir -p $JX_HOME"

                sh "jx --version"
                sh "jx step git credentials"

                sh "git config --global --add user.name JenkinsXBot"
                sh "git config --global --add user.email jenkins-x@googlegroups.com"

                sh "jx step bdd --config jx/bdd/clusters.yaml --gopath /tmp/cheese --git-provider=ghe --git-provider-url=https://github.beescloud.com --git-username dev1 --git-api-token $GHE_CREDS_PSW --default-admin-password $JENKINS_CREDS_PSW --no-delete-app --no-delete-repo --tests test-create-spring"

                /*
                dir ('/home/jenkins/go/src/github.com/jenkins-x/godog-jx'){
                    git "https://github.com/jenkins-x/godog-jx"
                    sh "make configure-ghe"
                }
                sh "./jx/scripts/ci-gke.sh"
                sh "jx version -b"

                // lets test we have the jenkins token setup
                sh "jx get pipeline"
                
                dir ('/home/jenkins/go/src/github.com/jenkins-x/godog-jx'){
                    git "https://github.com/jenkins-x/godog-jx"
                    sh "make bdd-tests"
                }
                */
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
