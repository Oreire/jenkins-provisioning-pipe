pipeline {
    agent any 
    environment {
        AWS_ACCESS_KEY_ID =  credentials ('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials ('AWS_SECRET_ACCESS_KEY')
        }
        parameters {
        choice (choices: "ALL\nINFRA\nAPPS\nDEL", description: " This is to manage pipeline steps", name: "DEPLOY_OPTIONS")
    }
    stages {
        stage('Initialise terraform') {
            steps {
                script {
                    echo "${params.DEPLOY_OPTIONS}"
                }
                sh '''
                cd dev
                terraform init
                
                '''
            }
        }

        /* stage('Terraform Format ') {
            when {
                expression  { params.DEPLOY_OPTIONS == 'INFRA' || params.DEPLOY_OPTIONS == 'ALL' }
            } 
            steps {
                sh '''
                cd dev
                terraform fmt -check
                
                '''
            }
        }
        stage('Terraform Validate ') {
            when {
                expression  { params.DEPLOY_OPTIONS == 'INFRA' || params.DEPLOY_OPTIONS == 'ALL' }
            } 
            steps {
                sh '''
                cd dev
                
                terraform validate
                '''
            }
        } */

        stage('Terraform Plan ') {
            when {
                expression  { params.DEPLOY_OPTIONS == 'INFRA' || params.DEPLOY_OPTIONS == 'ALL' }
            }
            steps {
                sh '''
                cd dev
                terraform plan -var 'node1=Nginx' -var 'node2=Pynode'
                '''
            }
        }

        stage('Terraform Apply ') {
            when {
                expression  { params.DEPLOY_OPTIONS == 'INFRA' || params.DEPLOY_OPTIONS == 'ALL' }
            }
            steps {
                sh '''
                cd dev
                terraform apply -var 'node1=Nginx' -var 'node2=Pynode' -auto-approve
                '''
            }
        }

        stage('Terraform Destroy ') {
            when {
                expression  { params.DEPLOY_OPTIONS == 'DEL' }
            }
            steps {
                sh '''
                cd dev
                terraform destroy -var 'node1=Nginx' -var 'node2=Pynode' -auto-approve
                '''
            }
        }

        stage('Manage Apps') {
            when {
                expression  { params.DEPLOY_OPTIONS == 'APPS' || params.DEPLOY_OPTIONS == 'ALL' }
            }
            environment {
                NGINX_NODE = sh(script: "cd dev; terraform output  |  grep Nginx | awk -F\\=  '{print \$2}'",returnStdout: true).trim()
                PYTHON_NODE = sh(script: "cd dev; terraform output  |  grep Pynode | awk -F\\=  '{print \$2}'",returnStdout: true).trim()
            }
            steps {
                script {
                    sshagent (credentials : ['PRIVATE_SSH_KEY']) {
                        sh """
                        env
                        cd dev
                        ssh -o StrictHostKeyChecking=no ec2-user@${NGINX_NODE} 'sudo yum update -y && sudo yum install git -y && sudo yum install nginx -y && sudo systemctl start nginx && sudo systemctl enable nginx'
                        ssh -o StrictHostKeyChecking=no ec2-user@${PYTHON_NODE} 'sudo yum update -y && sudo yum install python3 -y'
                        scp -o StrictHostKeyChecking=no ../hello.py ec2-user@${PYTHON_NODE}:/tmp/hello.py
                        """
                    }
                }
            }
        }
    }
}
        stage ('Notification') {
            steps {
                // Your build steps here
                echo 'This is the Build Outcome'
            }
                  
            post {
                success {
                    script {
                        withCredentials ([string (credentialsId: 'SLACK_TOKEN', variable: 'SLACK_ID')]) {

                        sh """
                          curl -X POST \
                          -H 'Authorization: Bearer ${SLACK_ID}' \
                          -H 'Content-Type: application/json' \
                          --data '{"channel": "devops-masterclass-2024","text" : "This Jenkins Alert indicates pipeline BUILD SUCCESS"}'  \
                          https://slack.com//api/chat.postMessage 
                        """
                    }
                }
        } 
            failure  {
                    script {
                        withCredentials ([string (credentialsId: 'SLACK_TOKEN', variable: 'SLACK_ID')]) {

                        sh """
                          curl -X POST \
                          -H 'Authorization: Bearer ${SLACK_ID}' \
                          -H 'Content-Type: application/json' \
                          --data '{"channel": "devops-masterclass-2024","text" : "This Jenkins Alert indicates pipeline BUILD FAILURE"}'  \
                          https://slack.com//api/chat.postMessage 
                        """
                    }
                }       
            }
        }
    }
}
