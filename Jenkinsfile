pipeline {
    agent any

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
                // Ajoutez ici les commandes pour exécuter les tests
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