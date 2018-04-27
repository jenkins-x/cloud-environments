pipeline {
    environment {
        GH_CREDS = credentials('jenkins-x-github')
        GKE_SA = credentials('gke-sa')
        GHE_CREDS = credentials('ghe-test-user')
        JENKINS_CREDS = credentials('test-jenkins-user')
        GIT_PROVIDER_URL = "https://github.beescloud.com"
    }
    agent {
        label "jenkins-go"
    }
    stages {
        stage('CI Build') {
            when {
                branch 'PR-*'
            }
            environment {
                CLUSTER_NAME = "JXCE-$BRANCH_NAME-$BUILD_NUMBER"
                ZONE = "europe-west1-b"
                PROJECT_ID = "jenkinsx-dev"
                SERVICE_ACCOUNT_FILE = "$GKE_SA"
                GHE_TOKEN = "$GHE_CREDS_PSW"
                JENKINS_PASSWORD="$JENKINS_CREDS_PSW"
            }
            steps {
                container('go') {
                    dir ('/home/jenkins/go/src/github.com/jenkins-x/godog-jx'){
                        git "https://github.com/jenkins-x/godog-jx"
                        sh "make configure-ghe"
                    }                    
                    sh "./jx/scripts/ci-gke.sh"
                    sh "jx version -b"
                    
/*
                    retry(3){
                        sh "jx create jenkins user --headless --password $JENKINS_PASSWORD admin"
                    }
*/

                    dir ('/home/jenkins/go/src/github.com/jenkins-x/godog-jx'){
                        git "https://github.com/jenkins-x/godog-jx"
                        sh "make bdd-tests"
                    }
                }
            }
            post {
                always {
                    echo 'Lets hang around....'
                    input "OK to terminate?"
                }
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
