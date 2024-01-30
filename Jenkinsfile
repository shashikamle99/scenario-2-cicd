pipeline {
    agent any
    triggers {
        pollSCM ('* * * * *')
    }
    environment {
        registry = "account_id.dkr.ecr.us-west-1.amazonaws.com/aws-docker-repo"
    }
    stages {
        stage('SCM') {
            steps {
                git branch: 'dev',
                url: 'https://github.com/shashikamle99/scenario-1-cicd.git'
            }
        }
        stage('Build package') {
            steps {
                sh "mvn clean install"
            }
        }
        stage('Build image') {
            steps {
                script {
                    dockerImage = docker.build registry 
                }
            }
        }
        stage('Pushing to ECR') {
            steps{  
                script {
                    sh 'aws ecr get-login-password --region us-west-1 | docker login --username AWS --password-stdin aws-docker-repo.dkr.ecr.us-west-1.amazonaws.com'
                    sh 'docker push account_id.dkr.ecr.us-west-1.amazonaws.com/aws-docker-repo:latest'
                }
             }
        }
    }
}