pipeline {
    agent any 
    environment {
        AWS_ACCESS_KEY_ID =  credentials ('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials ('AWS_SECRET_ACCESS_KEY')
        }
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
                terraform apply -var 'node1=Nginx' -var 'node2=Pynode' -auto-approve
                '''
            }
        }
        stage('Manage Nginx') {
            
            steps {
                script {
                    sshagent (credentials : ['SSH-TO-TERRA-Nodes']) {
                        sh """
                        cd dev
                        NGINX_NODE = "terraform output  |  grep Nginx | awk -F\\=  '{print \$2}'"
                        ssh -o StrictHostKeyChecking=no ec2-user@${NGINX_NODE} '
                                sudo yum update -y
                                sudo yum install nginx -y
                                sudo service nginx start 
                                sudo systemctl enable nginx '
                            """
                     }
                 }
             }
         }
    }
}