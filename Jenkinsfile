pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building the application...'
                sh 'mvn clean package'
            }
        }

        stage('Deploy to Server (Optional)') {
            steps {
                echo 'Copying JAR file to server...'
                sshagent(['server-ssh-credentials-id']) { // 使用 Jenkins 的 SSH 凭据
                    sh '''
                        scp target/demo-0.0.1-SNAPSHOT.jar user@yourserver:/opt/app/
                        ssh user@yourserver "systemctl restart your-springboot-app"
                    '''
                }
            }
        }

        stage('Build and Run Docker Image (Optional)') {
            when {
                expression { env.DEPLOY_DOCKER == "true" }
            }
            steps {
                echo 'Building Docker image...'
                sh '''
                    docker build -t demo-app .
                    docker run -d -p 8081:8081 --name demo-container demo-app
                '''
            }
        }
    }
}
