pipeline {
    environment {
        GH_CREDS = credentials('jenkins-x-github')
        GKE_SA = credentials('gke-sa')
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
                CLUSTER_NAME = "JXCE-$BRANCH_NAME"
                ZONE = "europe-west1-b"
                PROJECT_ID = "jenkinsx-dev"
                SERVICE_ACCOUNT_FILE = "$GKE_SA"
            }
            steps {
                container('go') {
                    sh "./jx/scripts/ci-gke.sh"
                    retry(3){
                        sh "jx create jenkins user --headless --password admin admin"
                    }

                    dir ('/home/jenkins/go/src/github.com/jenkins-x/godog-jenkins'){
                        git "https://github.com/jenkins-x/godog-jenkins"
                        sh "make bdd-cluster"
                    }
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
