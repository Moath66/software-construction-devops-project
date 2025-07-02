pipeline {
    agent { label 'built-in' }
    
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')
        DOCKER_IMAGE_NAME = 'moath070/software-construction-app'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
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
                    bat "docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} ."
                    bat "docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} ${DOCKER_IMAGE_NAME}:latest"
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                echo 'Pushing Docker Image to Docker Hub...'
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        bat "docker login -u %DOCKER_USER% -p %DOCKER_PASS%"
                        bat "docker push ${DOCKER_IMAGE_NAME}:${DOCKER_TAG}"
                        bat "docker push ${DOCKER_IMAGE_NAME}:latest"
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploying to Kubernetes Cluster...'
                script {
                    if (fileExists('k8s/')) {
                        bat 'kubectl apply -f k8s/'
                    } else {
                        error "Kubernetes config folder 'k8s/' not found!"
                    }
                }
            }
        }
    }
    
    post {
        always {
            script {
                try {
                    echo 'Pipeline completed. Cleaning Docker cache...'
                    bat 'docker system prune -f'
                } catch (Exception e) {
                    echo "Docker cleanup failed: ${e.getMessage()}"
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
