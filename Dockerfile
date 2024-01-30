FROM tomcat:9-jdk11-openjdk-slim
MAINTAINER kamle
COPY ./target/hello-world-1.0.war /usr/local/tomcat/webapps/
EXPOSE 8080