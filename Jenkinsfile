pipeline {
    agent any
    
    environment {
        NODE_VERSION = '24'
        NODE_PATH = 'C:\\Program Files\\nodejs'
        NPM_PATH = 'C:\\Program Files\\nodejs\\npm.cmd'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }
        
        stage('Verify Node.js') {
            steps {
                echo 'Verifying Node.js installation...'
                script {
                    if (isUnix()) {
                        sh 'node --version'
                        sh 'npm --version'
                    } else {
                        bat '"C:\\Program Files\\nodejs\\node.exe" --version'
                        bat '"C:\\Program Files\\nodejs\\npm.cmd" --version'
                    }
                }
            }
        }
        
        stage('Install Dependencies') {
            steps {
                echo 'Installing npm dependencies...'
                script {
                    if (isUnix()) {
                        sh 'npm ci'
                    } else {
                        bat '"C:\\Program Files\\nodejs\\npm.cmd" ci'
                    }
                }
            }
        }
        
        stage('Start Application') {
            steps {
                echo 'Starting the Node.js application...'
                script {
                    if (isUnix()) {
                        sh 'npm start &'
                        sh 'sleep 10'
                    } else {
                        bat 'start /B "C:\\Program Files\\nodejs\\npm.cmd" start'
                        bat 'timeout /T 10 >NUL'
                    }
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                echo 'Running application tests...'
                script {
                    if (isUnix()) {
                        sh 'npm test'
                    } else {
                        bat '"C:\\Program Files\\nodejs\\npm.cmd" test'
                    }
                }
            }
            post {
                always {
                    echo 'Cleaning up running processes...'
                    script {
                        if (isUnix()) {
                            sh 'pkill -f "node index.js" || true'
                        } else {
                            bat 'taskkill /F /IM node.exe || exit 0'
                        }
                    }
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
