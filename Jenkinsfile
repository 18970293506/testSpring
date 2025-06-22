
pipeline {
    agent any

    tools {
        maven 'maven-3.8.6'
    }

    environment {
        APP_NAME = "demo-app"
        // 删除 DOCKER_TAG 环境变量
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
                // 新增：存档构建产物
                archiveArtifacts artifacts: "target/*.jar", allowEmptyArchive: false
            }
        }
        // 新增：远程部署阶段
        stage('Deploy to Server') {
            steps {
                script {
                    echo '正在部署到服务器...'
                    // 使用 SSH 插件执行远程命令（需提前配置 SSH 凭据）
                    sshPublisher(
                        publishers: [
                            sshPublisherDesc(
                                configName: 'server-ssh-config', // Jenkins 系统设置的 SSH 配置名称
                                transfers: [
                                    transfer(
                                        sourceFiles: "target/*.jar",
                                        removePrefix: "target",
                                        remoteDirectory: "/opt/app"
                                    ),
                                    transfer(
                                        sourceFiles: "application.properties",
                                        remoteDirectory: "/opt/app/config"
                                    )
                                ]
                            ),
                            sshPublisherDesc(
                                configName: 'server-ssh-config',
                                transfers: [
                                    transfer(
                                        execCommand: '''
                                            # 停止旧服务
                                            pkill -f demo-app || true
                                            # 启动新服务
                                            nohup java -jar /opt/app/*.jar --spring.config.location=/opt/app/config/application.properties > /opt/app/app.log 2>&1 &
                                            echo "✅ 应用已启动"
                                        '''
                                    )
                                ]
                            )
                        ]
                    )
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