pipeline {
    agent any

    tools {
        maven 'maven3'
    }

    environment {
        AWS_REGION = "ap-south-1"
        ACCOUNT_ID = "044744845748"
        ECR_REPO = "java-app-repo"

        IMAGE_TAG = "${BUILD_NUMBER}"

        SONAR_HOME = tool 'sonar-scanner'
    }

    stages {

        stage('Checkout') {
            steps {
		git branch: 'main',
                url: 'https://github.com/sachinpriyadiyadisha929-dotcom/java-repo.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh '''
                    $SONAR_HOME/bin/sonar-scanner \
                    -Dsonar.projectKey=java-app \
                    -Dsonar.sources=. \
                    -Dsonar.java.binaries=.
                    '''
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                docker build -t java-app:${IMAGE_TAG} .
                '''
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region $AWS_REGION | \
                docker login --username AWS --password-stdin \
                $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

                docker tag java-app:${IMAGE_TAG} \
                $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:${IMAGE_TAG}

                docker push \
                $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:${IMAGE_TAG}
                '''
            }
        }

        stage('Deploy to EC2') {
            steps {
                sh '''
                ssh ubuntu@43.205.114.244 << EOF

                aws ecr get-login-password --region ap-south-1 | \
                docker login --username AWS --password-stdin \
                $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

                docker stop java-app || true
                docker rm java-app || true

                docker pull \
                $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:${IMAGE_TAG}

                docker run -d \
                --name java-app \
                -p 8080:8080 \
                $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:${IMAGE_TAG}

                EOF
                '''
            }
        }
    }
}
