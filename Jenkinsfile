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
        expression { params.DEPLOY_OPTIONS == 'APPS' }
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
        expression { params.DEPLOY_OPTIONS == 'APPS' }
    }
    environment {
        // Fetch Nginx node from Terraform output
        NGINX_NODE = sh(script: "cd dev; terraform output | grep Nginx_dns | awk -F= '{print \$2}'", returnStdout: true).trim()
        NGINX_CONFIG_PATH = '/etc/nginx/nginx.conf'
    }
    steps {
        script {
            sshagent(credentials: ['PRIVATE_SSH_KEY']) {
                // Modify Nginx config to listen on port 8080
                echo "Changing Nginx to listen on port 8080..."
                
                // Run the SSH command to change the Nginx config file and restart the service
                sh """
                    ssh -o StrictHostKeyChecking=no ec2-user@${NGINX_NODE} '
                        scp -o StrictHostKeyChecking=no NG.conf ec2-user@${NGINX_NODE}:/etc/nginx/nginx.conf
                        sudo nginx -t
                        sudo systemctl restart nginx
                        echo "Nginx is now listening on port 8080."
'
                """
            }
        }
    }
}

/* Uncomment and fix the following section if needed
        stage('Run Tests') {
            steps {
                sshagent(credentials: ['PRIVATE_SSH_KEY']) {
                    sh """
                    cd dev
                    PYTHON_NODE=$(terraform output -raw Pynode)
                    ssh -o StrictHostKeyChecking=no ec2-user@${PYTHON_NODE} 'cd /tmp/ ; sudo yum install python3-pip -y ; pip3 install pytest ; pytest hello.py'
                    """
                }
            }
        }
        */

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
                    --data '{"channel": "devops-masterclass-2024", "text": "This Jenkins Alert for pipeline BUILD SUCCESS for Week 10 Project"}' \
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
                    --data '{"channel": "devops-masterclass-2024", "text": "This Jenkins Alert indicates pipeline BUILD FAILURE for Week 10 Project"}' \
                    https://slack.com/api/chat.postMessage
                    """
                }
            }
        }
    }
}
