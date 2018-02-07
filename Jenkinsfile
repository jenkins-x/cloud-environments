pipeline {
    environment {
        GH_CREDS = credentials('jenkins-x-github')
        GKE_SA = credentials('gke-sa')
    }
    agent {
        label "jenkins-jx-base"
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
                container('jx-base') {
                    sh "./jx/scripts/ci-gke.sh"
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
