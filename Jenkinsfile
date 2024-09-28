pipeline {
    agent any
    environment {
        GIT_CREDENTIALS = credentials('git-credentials') // Git credentials
        DOCKER_CREDENTIALS = credentials('dockerhub-credentials') // Docker credentials
    }
 
    stages {
        stage('Checkout') {
            steps {
                sh '''
                    git config --global credential.helper store
                    echo "https://$GIT_CREDENTIALS" > ~/.git-credentials
                    if (fileExists('shifting-schedule')) {
                        dir('shifting-schedule') {
                            sh 'git fetch --all'
                            sh 'git reset --hard origin/main'
                        }
                    } else {
                    git clone https://github.com/hanstabotabo/shifting-schedule.git
                '''
            }
        }
        stage('Build') {
            steps {
                sh '''
                    echo "$DOCKER_CREDENTIALS" | docker login -u "$DOCKER_USERNAME" --password-stdin
                    docker login docker.io -u hanstabotabo -p 301315BebuGanda15!
                    docker pull docker.io/hanstabotabo/mini-proj
                '''
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sh 'kubectl apply -f deployment.yaml --validate=false'
                }
            }
        }
    }
}
