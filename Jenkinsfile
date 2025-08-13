pipeline {
    agent any
    
    environment {
        NODE_VERSION = '18'
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
                    if (isUnix()) {
                        env.PATH = "${nodeHome}/bin:${env.PATH}"
                    } else {
                        env.PATH = "${nodeHome};${env.PATH}"
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
                        bat 'npm ci'
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
                        bat 'start /B npm start'
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
                        bat 'npm test'
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
