pipeline {
    agent { label 'built-in' }  // ✅ Good - Forces main Jenkins node
    
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')
        DOCKER_IMAGE_NAME = 'moath070/software-construction-app'
        DOCKER_TAG = "${env.BUILD_NUMBER}"  // ✅ FIXED: Define DOCKER_TAG
    }
    
    stages {
        stage('Clean Workspace') {
            steps {
                echo 'Cleaning workspace before build...'
                cleanWs()
            }
        }
        
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                checkout scm
            }
        }
        
        stage('Docker Build & Tag') {
            steps {
                echo 'Building Docker Image with Backend and Frontend...'
                script {
                    if (isUnix()) {
                        sh "docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} ."
                        sh "docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} ${DOCKER_IMAGE_NAME}:latest"
                    } else {
                        bat "docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} ."
                        bat "docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} ${DOCKER_IMAGE_NAME}:latest"
                    }
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                echo 'Pushing Docker Image to Docker Hub...'
                script {
                    // ✅ FIXED: Use correct credential name
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                        if (isUnix()) {
                            sh "docker push ${DOCKER_IMAGE_NAME}:${DOCKER_TAG}"
                            sh "docker push ${DOCKER_IMAGE_NAME}:latest"
                        } else {
                            bat "docker push ${DOCKER_IMAGE_NAME}:${DOCKER_TAG}"
                            bat "docker push ${DOCKER_IMAGE_NAME}:latest"
                        }
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploying to Kubernetes Cluster...'
                script {
                    if (fileExists('k8s/')) {
                        if (isUnix()) {
                            sh 'kubectl apply -f k8s/'
                        } else {
                            bat 'kubectl apply -f k8s/'
                        }
                    } else {
                        error "Kubernetes config folder 'k8s/' not found!"
                    }
                }
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline completed. Cleaning Docker cache...'
            script {
                if (isUnix()) {
                    sh 'docker system prune -f'
                } else {
                    bat 'docker system prune -f'
                }
            }
        }
        success {
            echo 'Pipeline succeeded! 🎉'
        }
        failure {
            echo 'Pipeline failed! ❌'
        }
    }
}
