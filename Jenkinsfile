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
                        // Récupérer le contenu du rapport JUnit
                        //    def junitReport = readFile '**/target/surefire-reports/TEST-*.xml'
                            // Envoyer un e-mail avec le rapport JUnit
                        //    emailext body: "Le rapport de vos tests JUnit :\n\n ${junitReport}",
                        //        subject: "Rapport JUnit de todo_list",
                        //        to: "slim.hammami1977@gmail.com"
                        // Rechercher les rapports JUnit
                        sh 'find $WORKSPACE -name "TEST-*.xml"'

                        // Essayez d'afficher le contenu d'un fichier de rapport pour vérification
                        sh 'cat $(find $WORKSPACE -name "TEST-*.xml" -print -quit)'
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