pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                sh 'git clone https://github.com/hanstabotabo/shifting-schedule.git'
            }
        stage('Build') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker_credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                script {
                    sh '''
                    echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                    if [ "$(docker ps -q -f name=registry)" ]; then
                        docker stop registry
                        docker rm registry
                        docker run -d -p 5000:5000 --name registry registry:latest
                    else
                        docker run -d -p 5000:5000 --name registry registry:latest
                    fi
                    docker build . -t localhost:5000/mini-proj:stable --build-arg VERSION=stable
                    docker push localhost:5000/mini-proj:stable
                    docker build . -t localhost:5000/mini-proj:canary --build-arg VERSION=canary
                    docker push localhost:5000/mini-proj:canary
                    '''
                }
                }
            }
        }
        stage('Deploy') {
            steps {
                    withKubeConfig(caCertificate: "${KUBE_CERT}", clusterName: 'kubernetes', contextName: 'kubernetes-admin@kubernetes', credentialsId: 'my-kube-config-credentials', namespace: 'default', restrictKubeConfigAccess: false, serverUrl: 'https://jump-host:6443') {
                    sh 'kubectl apply -f pv-definition.yaml'
                    sh 'kubectl apply -f pvc-definition.yaml'
                    sh 'kubectl apply -f deployment-stable.yaml'
                    sh 'kubectl apply -f deployment-canary.yaml'
                    }
            }
        }
        stage('Push Updated Schedule to Git') {
            steps {
                withKubeConfig(caCertificate: "${KUBE_CERT}", clusterName: 'kubernetes', contextName: 'kubernetes-admin@kubernetes', credentialsId: 'my-kube-config-credentials', namespace: 'default', restrictKubeConfigAccess: false, serverUrl: 'https://jump-host:6443') {
                script {
                    sh '''
                    # Get a random pod name from the mini-proj-app deployment
                    RANDOM_POD=$(kubectl get pods -o name | grep mini-proj-app | shuf -n 1 | cut -d'/' -f2)
                    if [ -z "$RANDOM_POD" ]; then
                        echo "No pods found for mini-proj-app."
                        exit 1
                    fi

                    echo "Using pod: $RANDOM_POD"
                    
                    # Now use RANDOM_POD in kubectl cp
                    kubectl cp "$RANDOM_POD:/app/schedule.txt" ./shifting-schedule/schedule.txt

                    cd shifting-schedule

                    # Configure Git credentials
                    git config --global user.email "hanstabotabo@gmail.com"
                    git config --global user.name "Hans Tabotabo"
                    git config --global --add safe.directory /var/lib/jenkins/workspace/mini-proj

                    # Check contents of schedule.txt
                    echo "Contents of schedule.txt:"
                    cat ./schedule.txt

                    # Commit and push the updated file
                    git add schedule.txt
                    if [ -n "$(git status --porcelain)" ]; then
                        git commit -m "Update schedule.txt from Kubernetes job"
                    else
                        echo "No changes to commit."
                    fi
                    '''
                }
                }
            }
        }
    }
}
