pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'pip install -r requirements.txt'
                sh 'python manage.py collectstatic --noinput'
            }
        }

        stage('Deploy') {
            steps {
                sh 'sudo systemctl stop gunicorn'
                sh 'sudo cp -r . /var/www/myapp'
                sh 'sudo systemctl start gunicorn'
            }
        }
    }
}
