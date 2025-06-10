# 使用 JDK 8 的基础镜像
FROM openjdk:8-jdk-alpine

# 拷贝编译好的 JAR 文件
COPY target/demo-0.0.1-SNAPSHOT.jar app.jar

# 启动命令
ENTRYPOINT ["java", "-jar", "app.jar"]
