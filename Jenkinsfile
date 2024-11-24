pipeline {
    agent any 
    environment {
        AWS_ACCESS_KEY_ID =  credentials ('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials ('AWS_SECRET_ACCESS_KEY')
        }
    /* parameters {
        choice {choices: "ALL\nINFRA\nAPPS", description: "This is to organise and manage pipeline steps", name: "deploy_option"}
    } */
    stages {
        stage('Initialise terraform') {
            steps {
                sh '''
                cd dev
                terraform init
                '''
            }
        }
        stage('Terraform Plan ') {
            steps {
                sh '''
                cd dev
                terraform plan -var 'node1=Nginx' -var 'node2=Pynode'
                '''
            }
        }  
        stage('Terraform Apply ') {
            steps {
                sh '''
                cd dev
                terraform ${action} -var 'node1=Nginx' -var 'node2=Pynode' -auto-approve
                '''
            }
        }
        stage('Install Nginx') {
            environment {
                NGINX_NODE = sh(script: "cd dev; terraform output  |  grep Nginx | awk -F\\=  '{print \$2}'",returnStdout: true).trim()
            }
            steps {
                script {
                    sshagent (credentials : ['PRIVATE_SSH_KEY']) {
                        sh """
                        env
                        cd dev
                        ssh -o StrictHostKeyChecking=no ec2-user@${NGINX_NODE} 'sudo yum update -y && sudo yum install git -y && sudo yum install nginx -y && sudo systemctl start nginx && sudo systemctl enable nginx'
                        """
                    }
                }
            }
        }

        stage('Install Python') {
            environment {
                PYTHON_NODE = sh(script: "cd dev; terraform output  |  grep Pynode | awk -F\\=  '{print \$2}'",returnStdout: true).trim()
            }
            steps {
                script {
                    sshagent (credentials : ['PRIVATE_SSH_KEY']) {
                        sh """
                        env
                        cd dev
                        ssh -o StrictHostKeyChecking=no ec2-user@${PYTHON_NODE} 'sudo yum update -y && sudo yum install python3 -y'
                        scp -o StrictHostKeyChecking=no ../hello.py ec2-user@${PYTHON_NODE}:/tmp/hello.py
                                               
                        """
                    }
                }
            }
        }
        stage('Terraform Destroy ') {
            steps {
                sh '''
                cd dev
                terraform ${action} -var 'node1=Nginx' -var 'node2=Pynode' -auto-approve
                '''
            }
        }
    }
}