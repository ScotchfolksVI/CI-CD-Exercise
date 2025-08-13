pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }
        
        stage('Test Node.js') {
            steps {
                echo 'Testing Node.js installation...'
                script {
                    if (isUnix()) {
                        sh 'which node'
                        sh 'which npm'
                    } else {
                        bat 'dir "C:\\Program Files\\nodejs"'
                        bat '"C:\\Program Files\\nodejs\\node.exe" --version'
                        bat '"C:\\Program Files\\nodejs\\npm.cmd" --version'
                    }
                }
            }
        }
        
        stage('Install Dependencies') {
            steps {
                echo 'Installing dependencies...'
                script {
                    if (isUnix()) {
                        sh 'npm ci'
                    } else {
                        bat '"C:\\Program Files\\nodejs\\npm.cmd" ci'
                    }
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                echo 'Running tests...'
                script {
                    if (isUnix()) {
                        sh 'npm test'
                    } else {
                        bat '"C:\\Program Files\\nodejs\\npm.cmd" test'
                    }
                }
            }
        }
        
        stage('Success') {
            steps {
                echo 'Pipeline completed successfully!'
            }
        }
    }
}
