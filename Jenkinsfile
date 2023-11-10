pipeline {
    agent any
    tools {
            maven 'Maven3' // Use the name you provided while configuring Maven in Jenkins
        }
    stages {
        stage('Build') {
            steps {
                echo 'Etape de construction...'
                sh 'mvn clean package'
            }
        }
        stage('Test') {
            steps {
                echo 'Etape de test...'
                sh './mvnw test'
            }
            post {
                always {
                    junit '**/target/surefire-reports/TEST-*.xml'
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Etape de déploiement...'
                // Ajoutez ici les commandes pour le déploiement
            }
        }
        stage('Release') {
            steps {
                echo 'Etape de release...'
                // Ajoutez ici les commandes pour une éventuelle release
            }
        }
    }
}