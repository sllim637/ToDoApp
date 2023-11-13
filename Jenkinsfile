pipeline {
    agent any
    tools {
            maven 'Maven3' // Use the name you provided while configuring Maven in Jenkins
        }
    environment {
        SONARSERVER = 'sonarserver'
        SONARSCANNER = 'sonarscanner'
    }
    stages {
        stage('Build') {
            steps {
                echo 'Etape de construction...'
                sh 'mvn package -DskipTests'
            }
        }
        stage('Test + Email notification') {
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
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv("${SONARSERVER}") {
                sh "mvn clean verify sonar:sonar \
                -Dsonar.projectKey=TodoApp \
                -Dsonar.projectName=''TodoApp'' \
                -Dsonar.host.url=http://localhost:9000 \
                -Dsonar.token=sqp_a8d81e26191f1f0675c2655a0174804a0e836302
            }
            }
            
        }
        

        // stage('Performance Tests') {
        //     steps {
        //         // Étape pour les tests de performance avec Apache JMeter
        //         sh 'jmeter -n -t /path/to/performance_test.jmx -l /path/to/performance_results.jtl'
        //     }
        // }
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