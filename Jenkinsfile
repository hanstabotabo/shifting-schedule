pipeline {
    agent any
 
    stages {
        stage('Checkout') {
            steps {
                script {
                    if (fileExists('shifting-schedule')) {
                        dir('shifting-schedule') {
                            sh 'git fetch --all'
                            sh 'git reset --hard origin/main'
                        }
                    } else {
                        git 'https://github.com/hanstabotabo/shifting-schedule.git'
                    }
                }
            }
        }
        stage('Build') {
            steps {
                script {
                    sh 'docker login docker.io -u hanstabotabo -p 301315BebuGanda15!'
                    sh 'docker pull docker.io/hanstabotabo/mini-proj'
                }
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
