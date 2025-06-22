pipeline {
    agent any

    tools {
        maven 'maven-3.8.6'
    }

    environment {
        APP_NAME = "demo-app"
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
                archiveArtifacts artifacts: "target/*.jar", allowEmptyArchive: false
            }
        }
        stage('Deploy via SSH') {
            steps {
                script {
                    echo '正在通过 SSH 部署...'
                    // 使用 Jenkins 凭据管理
                    sshagent(['server-ssh-credentials-id']) { // 替换为实际凭据 ID
                        // 执行远程部署命令
                        sh '''
                            # 上传构建产物
                            scp -o StrictHostKeyChecking=no target/*.jar jenkins@192.168.134.131:/opt/app/
                            
                            # 上传配置文件（可选）
                            scp -o StrictHostKeyChecking=no application.properties jenkins@192.168.134.131:/opt/app/config/
                            
                            # 执行远程部署命令
                            ssh -o StrictHostKeyChecking=no jenkins@192.168.134.131 <<EOF
                                # 停止旧服务
                                pkill -f demo-app || true
                                
                                # 启动新服务
                                nohup java -jar /opt/app/*.jar --spring.config.location=/opt/app/config/application.properties > /opt/app/app.log 2>&1 &
                                
                                echo "✅ 应用已启动"
EOF
                        '''
                    }
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
