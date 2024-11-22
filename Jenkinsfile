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
        stage('INSTALL NGINX ON NODE 1') {
            steps {
                script {
                    sshagent (credentials : ['SSH_PRIVATE_KEY']) {
                        sh """
                        env
                        cd dev
                        NGINX_NODE = "terraform output  |  grep Nginx | awk -F\\=  '{print \$2}'",returnStdout: true).trim()
                        ssh  ec2-user@${NGINX_NODE} 'pwd'
                        ssh -o StrictHostKeyChecking=no ec2-user@${NGINX_NODE} << 'EOF'
                                'sudo yum update -y           # Update system (Amazon Linux)
                                sudo amazon-linux-extras enable nginx1.12  # Enable NGINX
                                sudo yum install nginx -y      # Install NGINX
                                sudo systemctl start nginx     # Start NGINX service
                                sudo systemctl enable nginx    # Enable NGINX on boot'
                       EOF
                            """
                    }
             }
    }

}