pipeline {
    agent any
    
    environment {
        NODE_VERSION = '24'
        NPM_CACHE = 'C:\\tmp\\.npm'
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
        
        stage('Setup Node.js') {
            steps {
                echo 'Setting up Node.js environment...'
                script {
                    // Set PATH to include Node.js
                    if (isUnix()) {
                        env.PATH = "/usr/local/bin:/usr/bin:${env.PATH}"
                    } else {
                        env.PATH = "C:\\Program Files\\nodejs;${env.PATH}"
                        // Verify Node.js is accessible
                        bat 'node --version'
                        bat 'npm --version'
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
                        // Use full path to npm
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
                        // Use full path to npm
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
                        // Use full path to npm
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
