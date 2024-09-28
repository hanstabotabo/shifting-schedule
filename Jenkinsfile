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
                    sh 'docker build . -t shift_sched'
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sh 'kubectl run mini-proj_pod --image shift_sched'
                }
            }
        }
    }
}
