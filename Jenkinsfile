/* groovylint-disable LineLength, NestedBlockDepth */
pipeline {
    agent any
    tools {
            maven 'Maven3' // Use the name you provided while configuring Maven in Jenkins
            terraform 'terraform'
    }
    environment {
        SONARSERVER = 'sonarserver'
        SONARSCANNER = 'sonarscanner'
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        SSH_KEY_CREDENTIALS_ID = credentials('AWS_PEM_FILE')
        EC2_PUBLIC_IP = '' // Placeholder for the public IP address
    }
    stages {
        stage('Build') {
            steps {
                echo 'Etape de construction...'
                sh 'mvn package -DskipTests'
            }
        }
        stage('Build and Dockerize') {
            steps {
                script {
                    // Assuming Dockerfile is in the root of your project
                    def dockerBuildCommand = 'docker build -t todoapp .'

                    // Execute Maven build and Docker build commands
                    sh """
                mvn clean install -DskipTests &&
                ${dockerBuildCommand}
            """
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                        // Log in to Docker Hub
                        sh """
                    echo "${DOCKER_HUB_PASSWORD}" | docker login -u ${DOCKER_HUB_USERNAME} --password-stdin
                """

                        // Tag the image with the Docker Hub repository name
                        sh "docker tag todoapp ${DOCKER_HUB_USERNAME}/todoapp"

                        // Push the image to Docker Hub
                        sh "docker push ${DOCKER_HUB_USERNAME}/todoapp"
                    }
                }
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
                        subject: 'Rapports JUnit',
                        to: 'slim.hammami1977@gmail.com'
                    }
                }
            }
        }
        stage('SonarQube Analysis') {
            steps {
                //     withSonarQubeEnv("${SONARSERVER}") {
                //     sh '''mvn clean verify sonar:sonar \
                //     -Dsonar.projectKey=TodoApp \
                //     -Dsonar.projectName=''TodoApp'' \
                //     -Dorg.slf4j.simpleLogger.defaultLogLevel=debug '''
                // }
                echo 'static code analysis simulations'
            }
        }

        // stage('Performance Tests') {
        //     steps {
        //         // Étape pour les tests de performance avec Apache JMeter
        //         sh 'jmeter -n -t /path/to/performance_test.jmx -l /path/to/performance_results.jtl'
        //     }
        // }
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform Apply') {
            steps {
                script {
                    // Utiliser withEnv pour définir des variables d'environnement dynamiquement si nécessaire
                    withEnv(["AWS_ACCESS_KEY_ID=${env.AWS_ACCESS_KEY_ID}", "AWS_SECRET_ACCESS_KEY=${env.AWS_SECRET_ACCESS_KEY}"]) {
                        sh 'terraform apply -auto-approve'
                        // Assigner la valeur de l'IP publique à la variable EC2_PUBLIC_IP
                        EC2_PUBLIC_IP = sh(script: 'terraform output -raw instance_public_ip', returnStdout: true).trim()
                    }
                    // Enregistrer le contenu de la variable EC2_PUBLIC_IP
                    echo "L'adresse IP publique de l'instance EC2 est : ${EC2_PUBLIC_IP}"
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Etape de déploiement...'
                // Ajoutez ici les commandes pour le déploiement
                sshagent([SSH_KEY_CREDENTIALS_ID]) {
                    script {
                        def dockerVersion = sh(script: "ssh -i ${SSH_KEY_CREDENTIALS_ID} -o StrictHostKeyChecking=no ubuntu@${EC2_PUBLIC_IP} 'sudo docker --version'", returnStdout: true).trim()

                        if (dockerVersion) {
                            echo "Docker is installed. Version: ${dockerVersion}"
            } else {
                            sh """
                    ssh -i ${SSH_KEY_CREDENTIALS_ID} -o StrictHostKeyChecking=no ubuntu@${EC2_PUBLIC_IP} \
                    "sudo sh -c '
                        apt-get update &&
                        apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common &&
                        mkdir -p /etc/apt/keyrings &&
                        curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.gpg &&
                        gpg --batch --dearmor /etc/apt/keyrings/docker.gpg &&
                        echo \"deb [arch=\$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \$(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null &&
                        apt update &&
                        apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin &&
                        docker compose version
                    '"
                """
                        }
                    }
                }
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
