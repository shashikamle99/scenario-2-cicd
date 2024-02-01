pipeline {
    agent any
    // triggers {
    //     pollSCM ('* * * * *')
    // }
    environment {
        registry = "855879423727.dkr.ecr.us-west-1.amazonaws.com/aws-docker-repo"
    }
    stages {
        stage('SCM') {
            steps {
                git branch: 'dev',
                url: 'https://github.com/shashikamle99/scenario-2-cicd.git'
            }
        }
        stage('Build package') {
            steps {
                sh "mvn clean package"
            }
        }

        stage('SonarQube Analysis') {
          steps {
              withSonarQubeEnv('SONAR_CLOUD') {
                sh "mvn sonar:sonar -Dsonar.projectKey=java-project-demo -Dsonar.organization=java-project-demo -Dsonar.token=a64e938e4479814e8dd3a080e2b085270f7d884b"
                }
            } 
        }

        stage('Junit Reports') {
            steps {
                junit '**/target/surefire-reports/TEST-*.xml'
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
                    sh 'aws ecr get-login-password --region us-west-1 | docker login --username AWS --password-stdin 855879423727.dkr.ecr.us-west-1.amazonaws.com'
                    sh 'docker push 855879423727.dkr.ecr.us-west-1.amazonaws.com/aws-docker-repo:latest'
                }
            }
        }
        stage('K8S Deploy') {
            steps{   
                script {
                    withKubeConfig([credentialsId: 'K8S-config', serverUrl: '']) {
                    sh ('kubectl apply -f  java-app.yml')
                    sh ('kubectl apply -f  alb-service.yml')

                    }
                }
            }
        }
    }
}