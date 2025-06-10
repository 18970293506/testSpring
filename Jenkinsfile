pipeline {
    agent any

    tools {
        maven 'maven-3.8.6'
    }

    environment {
        APP_NAME = "demo-app"
        DOCKER_TAG = "latest"
    }

    stages {
        stage('Clone Code') {
            steps {
                echo '克隆代码...'
                git branch: 'master', url: 'https://github.com/18970293506/testSpring.git'
            }
        }

        stage('Build with Maven') {
            steps {
                echo 'Maven 构建中...'
                sh 'mvn clean package'
            }
        }

        stage('Build and Run Docker Image') {
            steps {
                echo '构建并运行 Docker 镜像...'
                sh '''
                    docker stop ${APP_NAME}-container || true
                    docker rm ${APP_NAME}-container || true
                    docker rmi ${APP_NAME}:${DOCKER_TAG} || true
                    docker build -t ${APP_NAME}:${DOCKER_TAG} .
                    docker run -d -p 8081:8081 --name ${APP_NAME}-container ${APP_NAME}:${DOCKER_TAG}
                '''
            }
        }
    }

    post {
        success {
            echo '✅ 构建和部署成功！'
        }
        failure {
            echo '❌ 构建失败，请检查日志。'
        }
    }
}
