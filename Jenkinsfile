pipeline {
    agent any
    
    environment {
        NODE_VERSION = '24'
        NPM_CACHE = '/tmp/.npm'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }
        
        stage('Setup Node.js') {
            steps {
                echo 'Setting up Node.js environment...'
                script {
                    def nodeHome = tool name: 'NodeJS-18', type: 'jenkins.plugins.nodejs.tools.NodeJSInstallation'
                    env.PATH = "${nodeHome}/bin:${env.PATH}"
                }
            }
        }
        
        stage('Install Dependencies') {
            steps {
                echo 'Installing npm dependencies...'
                sh 'npm ci'
            }
        }
        
        stage('Start Application') {
            steps {
                echo 'Starting the Node.js application...'
                sh 'npm start &'
                sh 'sleep 10'
            }
        }
        
        stage('Run Tests') {
            steps {
                echo 'Running application tests...'
                sh 'npm test'
            }
            post {
                always {
                    echo 'Cleaning up running processes...'
                    sh 'pkill -f "node index.js" || true'
                }
            }
        }
        
        stage('Build Status') {
            steps {
                echo 'Build completed successfully!'
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline execution completed'
            cleanWs()
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
