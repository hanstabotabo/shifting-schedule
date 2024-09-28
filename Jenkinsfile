pipeline {
    agent {
        label 'docker'
    }

    stages {
        /*stage('Checkout') {
            steps {
                //git branch: 'main', credentialsId: 'github', url: 'https://github.com/hanstabotabo/shifting-schedule.git'
                sh '''
                if (fileExists('shifting-schedule')) {
                    dir('shifting-schedule') {
                        git fetch --all'
                        sh 'git reset --hard origin/main'
                    }
                } else {
                    git clone https://github.com/hanstabotabo/shifting-schedule.git
                }
                '''
            }
        }*/
        stage('Run/Clean Registry') {
            steps {
                if (sh(script: 'docker ps -q -f name=registry', returnStdout: true).trim()) {
                    sh 'docker stop registry'
                    sh 'docker rm registry'
                } else {
                    docker run -d -p 5000:5000 --name registry registry:2
                }
            }
        }
        stage('Build') {
            steps {
                //withCredentials([usernamePassword(credentialsId: 'docker-host-ssh-creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                //sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                /*sh '''
                echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                docker pull docker.io/hanstabotabo/mini-proj
                '''*/
                sh '''
                docker build . -t mini-proj:latest
                docker tag mini-proj:latest localhost:5000/mini-proj:latest
                docker push localhost:5000/mini-proj:latest
                '''
                //sh 'docker pull docker.io/hanstabotabo/mini-proj'
                //}
            }
        }
        stage('Deploy') {
            steps {
                    withKubeConfig(caCertificate: "${KUBE_CERT}", clusterName: 'kubernetes', contextName: 'kubernetes-admin@kubernetes', credentialsId: 'my-kube-config-credentials', namespace: 'default', restrictKubeConfigAccess: false, serverUrl: 'https://jump-host:6443') {
                    sh 'kubectl apply -f deployment.yaml'
                    }
            }
        }
    }
}
