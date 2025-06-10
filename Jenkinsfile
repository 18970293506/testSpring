pipeline {
    agent any

    tools {
        maven 'maven-3.8.6' // 这个名字要和 Global Tool Configuration 中一致
    }

    environment {
        APP_NAME = "demo-app"
        DOCKER_TAG = "latest"
        SERVER_IP = "your.server.ip.address"  // 替换为你的服务器 IP
        SSH_CRED_ID = "server-ssh-credentials"  // Jenkins 中配置的 SSH 凭据 ID
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

        stage('Build Docker Image') {
            steps {
                echo '构建 Docker 镜像...'
                sh 'docker build -t ${APP_NAME}:${DOCKER_TAG} .'
            }
        }

        stage('Deploy to Server via SSH') {
            steps {
                echo '通过 SSH 部署到服务器...'
                sshagent([SSH_CRED_ID]) {
                    sh '''
                        scp target/demo-0.0.1-SNAPSHOT.jar user@${SERVER_IP}:/opt/app/
                        ssh user@${SERVER_IP} <<EOF
                            docker stop demo-container || true
                            docker rm demo-container || true
                            docker rmi ${APP_NAME}:${DOCKER_TAG} || true
                            cd /opt/app
                            docker build -t ${APP_NAME}:${DOCKER_TAG} .
                            docker run -d -p 8081:8081 --name demo-container ${APP_NAME}:${DOCKER_TAG}
EOF
                    '''
                }
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
