pipeline {
    agent any
    
    stages {
        /*stage('Run/Clean Registry') {
            steps {
                script {
                    if (sh(script: 'docker ps -q -f name=registry', returnStdout: true).trim()) {
                        sh '''
                        docker stop registry
                        docker rm registry
                        docker run -d -p 5000:5000 --name registry registry:2
                        '''
                    } else {
                        sh 'docker run -d -p 5000:5000 --name registry registry:2'
                    }
                }
            }
        }*/
        stage('Build') {
            steps {
                //withCredentials([usernamePassword(credentialsId: 'docker-host-ssh-creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                //sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                //echo 'nameserver 8.8.8.8' >> /etc/resolv.conf
                sh '''
                docker build . -t mini-proj:latest
                if [ "$(docker ps -q -f name=registry)" ]; then
                    docker stop registry
                    docker rm registry
                    docker run -d -p 5000:5000 --name registry registry:2
                else
                    docker run -d -p 5000:5000 --name registry registry:2
                fi
                docker tag mini-proj:latest localhost:5000/mini-proj:latest
                docker push localhost:5000/mini-proj:latest
                '''
            }
        }
        stage('Deploy') {
            steps {
                script {
                    withKubeConfig(caCertificate: "${KUBE_CERT}", clusterName: 'kubernetes', contextName: 'kubernetes-admin@kubernetes', credentialsId: 'my-kube-config-credentials', namespace: 'default', restrictKubeConfigAccess: false, serverUrl: 'https://jump-host:6443') {
                        //sh 'kubectl apply -f service-definition.yaml'
                        sh 'kubectl apply -f deployment.yaml'
                    }
                }
            }
        }
    }
}
