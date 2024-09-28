pipeline {
    agent any
 
    stages {
        stage('Checkout') {
            steps {
                script {
                    sh 'git clone https://github.com/hanstabotabo/shifting-schedule.git'
                }
            }
        }
        stage('Build') {
            steps {
                script {
                    sh 'docker pull hanstabotabo/shift_sched"
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sh 'kubectl run mini-proj_pod --image hanstabotabo/shift_sched'
                }
            }
        }
    }
}
