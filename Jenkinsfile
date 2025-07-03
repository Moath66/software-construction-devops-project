pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKER_IMAGE_NAME = 'moath070/software-construction-app'
        DOCKER_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                checkout scm
            }
        }

        stage('Build Backend') {
            steps {
                echo 'Building Backend Application...'
                dir('css_backend') {
                    script {
                        if (isUnix()) {
                            sh 'npm install'
                        } else {
                            bat 'npm install'
                        }
                    }
                }
            }
        }

        stage('Build Frontend') {
            steps {
                echo 'Building Frontend Application...'
                dir('css_frontend') {
                    script {
                        if (isUnix()) {
                            sh 'npm install'
                        } else {
                            bat 'npm install'
                        }
                    }
                }
            }
        }

        stage('Create Docker Image') {
            steps {
                echo 'Creating Docker Image...'
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
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
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
                echo 'Deploying to Kubernetes...'
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    script {
                        if (isUnix()) {
                            sh 'kubectl apply -f k8s/'
                        } else {
                            bat 'kubectl apply -f k8s/'
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed!'
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
