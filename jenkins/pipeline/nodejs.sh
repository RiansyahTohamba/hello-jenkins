# untuk kasus 2 server 
# server jenkins berada di ip 10.2.32.222.
# server nodejs berada di ip 10.2.32.133.
pipeline {
  agent any
  
  stages {
    stage('Build') {
      steps {
        # Clone the Git repository
        git 'https://github.com/example/my-node-app.git'
        
        # Install Node.js dependencies
        sh 'npm install'
      }
    }
    
    stage('Test') {
      steps {
        # Run unit tests
        sh 'npm test'
      }
    }
    
    stage('Deploy to Node.js Server') {
      environment {
        SSH_KEY = credentials('my-ssh-key')
        NODE_SERVER = '10.2.32.133'
        NODE_USER = 'nodeuser'
        NODE_PATH = '/var/www/my-node-app'
      }
      steps {
        # Copy the files to the remote server using SSH
        sshagent(['$SSH_KEY']) {
          sh "rsync -avz --delete -e 'ssh -o StrictHostKeyChecking=no' ./ $NODE_USER@$NODE_SERVER:$NODE_PATH"
        }
        
        # Restart the Node.js server
        sshagent(['$SSH_KEY']) {
          sh "ssh -o StrictHostKeyChecking=no $NODE_USER@$NODE_SERVER 'sudo systemctl restart my-node-app'"
        }
      }
    }
  }
}
