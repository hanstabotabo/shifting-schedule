pipeline {
    agent {
        label 'docker'
    }

    parameters {
        string(name: 'DOCKER_USERNAME', defaultValue: '', description: 'Docker Hub Username')
        password(name: 'DOCKER_PASSWORD', defaultValue: '', description: 'Docker Hub Password')
    }

    stages {
        stage('Run/Clean Registry') {
            steps {
                script {
                    if (sh(script: 'docker ps -q -f name=registry', returnStdout: true).trim()) {
                        sh '''
                        docker stop registry
                        docker rm registry
                        '''
                    } else {
                        sh 'docker run -d -p 5000:5000 --name registry registry:2'
                    }
                }
            }
        }
        stage('Build') {
            steps {
                //withCredentials([usernamePassword(credentialsId: 'docker-host-ssh-creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                //sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                //sh '''
                //echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                //'''*/
                sh '''
                echo $DOCKER_PASSWORD | docker login $DOCKER_USERNAME --password-stdin
                docker build . -t mini-proj:latest
                docker tag mini-proj:latest localhost:5000/mini-proj:latest
                docker push localhost:5000/mini-proj:latest
                '''
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
