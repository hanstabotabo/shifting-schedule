pipeline {
    agent {
        label "mini-proj"
    }
 
    stages {
        stage('Build') {
            steps {
                script {
                    sh 'docker build . -t hanstabotabo/mini-proj'
                    sh 'docker push hanstabotabo/mini-proj'
                    sh 'docker run -d -p 8080:8080 hanstabotabo/mini-proj'
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sh 'docker run -d -p 8080:8080 hanstabotabo/mini-proj'
                }
            }
        }
    }
}
