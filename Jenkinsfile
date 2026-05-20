pipeline {
    agent any

    tools {
        maven 'maven3'
    }

    stages {

        stage('Checkout') {
            steps {
                git 'https://github.com/https://github.com/sachinpriyadiyadisha929-dotcom/java-repo.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Run Application') {
            steps {
                sh 'java -cp target/java-demo-app-1.0.jar App'
            }
        }
    }
}
