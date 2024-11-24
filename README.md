# jenkins-provisioning-pipe

# dev folder contains the Terraform configuration files with the output
    

# Jenkinsfile contains the pipeline scripts for the provisioning of Node 1 (Nginx) & Node 2 (Pynode)
  
  ##Five key stages defined:

    ##Terraform Initialisation

    ##Terraform Plan
    
    ##Terraform Apply
    
    ##Install Nginx
    
    ##Install Python

# Parameters were created through the Jenkins UI to accept Actions such as : 
  
  ##apply
  
  ##destroy

# AWS Credentials
  
  ##The Jenkine pipeline was configured to accpet thes secret keys via the Jenkins UI

# SSH Credentials

  ##This was also configured through the Jenkins UI

# Jenkins-Server

  #Hosted on Docker Image 
  
  #Docker Image located on EC2 (t2.small) Instance created manually 
  
  #NB: The t2.small is NOT part of the Free Tier

 # Jenkins Plugins configured:

    ##SSH-AGENT
 
    ##Terraform 
    
    