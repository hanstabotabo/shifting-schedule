pipeline {
    agent any

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
        stage('Build') {
            steps {
                //withCredentials([usernamePassword(credentialsId: 'docker-host-ssh-creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                //sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                /*sh '''
                echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                docker pull docker.io/hanstabotabo/mini-proj
                '''*/
                script {
                    docker.withServer('tcp://docker-host:2376', 'docker-credentials-id') {
                    docker.withRegistry('http://localhost:5000', '') {
                        sh '''
                        docker build . -t mini-proj:latest
                        docker run -d -p 5000:5000 --name registry registry:2
                        docker tag mini-proj:latest localhost:5000/mini-proj:latest
                        docker push localhost:5000/mini-proj:latest
                        '''
                //sh 'docker pull docker.io/hanstabotabo/mini-proj'
                //}
                    }
                    }
                }
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
