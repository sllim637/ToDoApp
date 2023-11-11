pipeline {
    agent any
    tools {
            maven 'Maven3' // Use the name you provided while configuring Maven in Jenkins
        }
    stages {
        stage('Build') {
            steps {
                echo 'Etape de construction...'
                sh 'mvn package -DskipTests'
            }
        }
        stage('Test') {
            steps {
                echo 'Etape de test...'
                sh 'mvn test'
            }
            post {
                always {
                    script {
                        // Rechercher les rapports JUnit
                        def junitReports = sh script: 'find $WORKSPACE -name "TEST-*.xml"', returnStdout: true
                        // Envoyer les rapports par e-mail
                        emailext body: junitReports,
                        subject: "Rapports JUnit",
                        to: "slim.hammami1977@gmail.com"
                                }
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