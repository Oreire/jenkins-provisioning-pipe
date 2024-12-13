pipeline {
    agent any 
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    parameters {
        choice(choices: "ALL\nINFRA\nAPPS\nDEL\nFMTVAL", description: "This enforces Separation of Concerns SoC to manage pipeline steps", name: "DEPLOY_OPTIONS")
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

        stage('Terraform Format and Validate') {
            when {
                expression { params.DEPLOY_OPTIONS == 'FMTVAL' || params.DEPLOY_OPTIONS == 'ALL' }
            }
            steps {
                sh '''
                cd dev
                terraform fmt -recursive
                terraform fmt -check
                terraform validate
                '''
            }
        }
        
        stage('Terraform Plan') {
            when {
                expression { params.DEPLOY_OPTIONS == 'INFRA' || params.DEPLOY_OPTIONS == 'ALL' }
            }
            steps {
                sh '''
                cd dev
                terraform plan -var 'node1=Nginx' -var 'node2=Pynode'
                '''
            }
        }

        stage('Terraform Apply') {
            when {
                expression { params.DEPLOY_OPTIONS == 'INFRA' || params.DEPLOY_OPTIONS == 'ALL' }
            }
            steps {
                sh '''
                cd dev
                terraform apply -var 'node1=Nginx' -var 'node2=Pynode' -auto-approve
                '''
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.DEPLOY_OPTIONS == 'DEL' }
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
        expression { params.DEPLOY_OPTIONS == 'APPS' || params.DEPLOY_OPTIONS == 'ALL' }
    }
    environment {
        NGINX_NODE = sh(script: "cd dev; terraform output | grep Nginx_dns | awk -F= '{print \$2}'", returnStdout: true).trim()
        PYTHON_NODE = sh(script: "cd dev; terraform output | grep Pynode_dns | awk -F= '{print \$2}'", returnStdout: true).trim()
    }
    steps {
        script {
            sshagent(credentials: ['PRIVATE_SSH_KEY']) {
                sh """
                env
                cd dev
                ssh -o StrictHostKeyChecking=no ec2-user@${NGINX_NODE} '
                sudo yum install nginx -y
                sudo systemctl start nginx
                sudo systemctl enable nginx 
                '
                 
                ssh -o StrictHostKeyChecking=no ec2-user@${PYTHON_NODE} '
                sudo yum update -y
                sudo yum install python3 -y '
                scp -o StrictHostKeyChecking=no ../hello.py ec2-user@${PYTHON_NODE}:/tmp/hello.py

                """
            }
        }
    }
}
    stage('Modify Nginx Port') {
            when {
                expression { params.DEPLOY_OPTIONS == 'APPS' || params.DEPLOY_OPTIONS == 'ALL' }
            }
    environment {
        NGINX_CONFIG_PATH = '/etc/nginx/nginx.conf'
        LOCAL_FILE_PATH = 'NG.conf'
    }
            steps {
                script {
                    // Fetch Nginx node from Terraform output
                    NGINX_NODE = sh(script: "cd dev; terraform output | grep Nginx_dns | awk -F= '{print \$2}'", returnStdout: true).trim()

                    // Ensure SSH key is available
                    sshagent(credentials: ['PRIVATE_SSH_KEY']) {
                        echo "Changing Nginx to listen on port 8080..."
                        
                        // Copy the config file and update Nginx settings
                        sh """
                            scp -o StrictHostKeyChecking=no ${LOCAL_FILE_PATH} ec2-user@${NGINX_NODE}:~/
                            ssh -o StrictHostKeyChecking=no ec2-user@${NGINX_NODE} '
                                sudo mv ~/NG.conf ${NGINX_CONFIG_PATH}
                                sudo nginx -t
                                sudo systemctl restart nginx
                                echo "Nginx is now listening on port 8080"
                            '
                        """
            }
        }
    }
}
stage('Run Tests') {
    when {
        expression { params.DEPLOY_OPTIONS == 'APPS' || params.DEPLOY_OPTIONS == 'ALL' }
    }
    environment {
        PYTHON_NODE = sh(script: "cd dev; terraform output -raw Pynode_dns", returnStdout: true).trim()
        LOCAL_FILE_PATH_2 = 'python.service'
    }
    steps {
        echo "Python node value: ${PYTHON_NODE}"  // Debugging step to check the hostname
        sshagent(credentials: ['PRIVATE_SSH_KEY']) {
            sh '''
            cd dev
            scp -o StrictHostKeyChecking=no ${LOCAL_FILE_PATH_2} ec2-user@${PYTHON_NODE}:~/
            ssh -o StrictHostKeyChecking=no ec2-user@${PYTHON_NODE} 'cd /tmp/ ; sudo yum update -y ; sudo yum install python3-pip -y ; pip3 install pytest ; pytest hello.py ; sudo systemctl daemon-reload ; sudo systemctl enable python.service ; sudo systemctl start python.service'
            



            '''
        }
    }
}
stage('Notification') { 
            steps { 
                echo 'This stage provides the slack notification for the outcome of the pipeline Build' 
            }
        }
    }

    post {
        success {
            script {
                withCredentials([string(credentialsId: 'SLACK_TOKEN', variable: 'SLACK_ID')]) {
                    sh """
                    curl -X POST \
                    -H 'Authorization: Bearer ${SLACK_ID}' \
                    -H 'Content-Type: application/json' \
                    --data '{"channel": "devops-masterclass-2024", "text": "NGINX SERVER SUCCESSFULLY CONFIGURED AS A REVERSE PROXY"}' \
                    https://slack.com/api/chat.postMessage
                    """
                }
            }
        }
        failure {
            script {
                withCredentials([string(credentialsId: 'SLACK_TOKEN', variable: 'SLACK_ID')]) {
                    sh """
                    curl -X POST \
                    -H 'Authorization: Bearer ${SLACK_ID}' \
                    -H 'Content-Type: application/json' \
                    --data '{"channel": "devops-masterclass-2024", "text": "NGINX SERVER FAILED CONFIGURATION AS A REVERSE PROXY"}' \
                    https://slack.com/api/chat.postMessage
                    """
                }
            }
        }
        // UTILISES THE WORKSPACE CLEANUP PLUGIN
        always { 
            echo 'Commences the Cleaning up of the Working Directory after each BUILD' 
            cleanWs()
            echo 'The Workspace Cleanup process was successful'    
        }
        
    }
}
