pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build and Push Image') {
            environment {
                DOCKER_IMAGE = 'your-username/myapp'
            }
            steps {
                script {
                    sh 'docker build -t $DOCKER_IMAGE .'
                    withCredentials([string(credentialsId: 'DOCKER_HUB_CREDENTIALS', variable: 'DOCKER_HUB_CREDENTIALS')]) {
                        sh "echo $DOCKER_HUB_CREDENTIALS | docker login -u your-username --password-stdin"
                        sh "docker push $DOCKER_IMAGE"
                    }
                }
            }
        }

        stage('Deploy') {
            environment {
                DOCKER_IMAGE = 'your-username/myapp'
            }
            steps {
                sh 'docker stop myapp || true'
                sh 'docker rm myapp || true'
                sh 'docker run -d --name myapp -p 8000:8000 $DOCKER_IMAGE'
            }
        }
    }
}
