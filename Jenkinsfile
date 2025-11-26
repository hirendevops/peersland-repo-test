pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package' // Update with your project build command
            }
        }

        stage('Unit Tests') {
            steps {
                sh 'mvn test' // Or any other unit testing framework
            }
        }

        stage('SonarQube Analysis') {
            environment {
                scannerHome = tool 'sonar'
            }
            steps {
                withSonarQubeEnv('sonar') {
                    sh '${scannerHome}/bin/sonar-scanner'
                }
            }
        }
    }
}