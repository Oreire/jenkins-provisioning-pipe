# jenkins-provisioning-pipe
# Designed a modular Jenkins pipeline for secure cloud provisioning, app deployment, and automated testing using Terraform, SSH, and Slack notifications

Overview:
Designed and implemented a modular Jenkins pipeline to automate secure cloud provisioning, remote application deployment, and continuous delivery workflows. The pipeline leveraged Terraform for Infrastructure as Code (IaC), ensuring consistent and repeatable provisioning of cloud resources. Jenkins orchestrated the end‑to‑end workflow, including infrastructure setup, application configuration, and automated testing. Real‑time Slack integration provided immediate feedback on build and deployment status, enhancing collaboration and visibility across teams. This project demonstrates best practices in IaC, secure remote management, and CI/CD automation, delivering a scalable and production‑ready DevOps solution.

Tools & Technologies

• Jenkins (pipeline orchestration)
• Terraform (Infrastructure as Code)
• Slack (real‑time CI/CD feedback)
• Cloud provider (AWS/Azure, depending on implementation)
• Remote deployment & testing frameworks


This project implements a fully automated, **Terraform-driven CI/CD pipeline** for provisioning infrastructure, deploying and configuring applications, running tests, and delivering real-time feedback via Slack — all orchestrated through **Jenkins**. It demonstrates **best practices in Infrastructure as Code (IaC)**, **secure remote management**, and **continuous delivery workflows**.

## 🚀 Overview

The pipeline enables teams to:

* **Provision cloud infrastructure** using Terraform.
* **Deploy and configure applications** remotely via SSH.
* **Run automated tests** to validate deployments.
* **Receive instant Slack notifications** for operational awareness.
* Maintain a **clean, repeatable, and parameterised** deployment process.

It’s designed to be **flexible** — allowing you to run only the stages you need, from full deployment to targeted tasks like code validation or infrastructure teardown.


## 🔑 Key Features

1. **Flexible Deployment Options**

   * Controlled via the `DEPLOY_OPTIONS` parameter to separate concerns:

     * `ALL` – Full pipeline (infra + apps)
     * `INFRA` – Terraform plan and apply only
     * `APPS` – Deploy and configure applications only
     * `FMTVAL` – Format and validate Terraform code
     * `DEL` – Destroy infrastructure

2. **Infrastructure as Code (Terraform)**

   * Initialises Terraform in the `dev` directory.
   * Formats and validates Terraform files for style and syntax.
   * Plans and applies infrastructure with defined variables (e.g., `node1=Nginx`, `node2=Pynode`).
   * Supports clean and complete infrastructure teardown.

3. **Application Deployment & Management**

   * Retrieves Terraform outputs (e.g., EC2 instance DNS names).
   * Connects securely to nodes via Jenkins-managed SSH keys.
   * Installs **Nginx** and **Python3**, configures Nginx to listen on port `8080`.
   * Deploys Python application code to the Python node.

4. **Automated Testing**

   * Executes `pytest` remotely on the Python node to verify application functionality.

5. **Real-Time Slack Notifications**

   * Sends build success or failure updates to a Slack channel.
   * Provides quick operational visibility for the team.

6. **Post-Build Workspace Cleanup**

   * Always cleans the Jenkins workspace after a build to prevent artefact contamination in future runs.



## 📦 Prerequisites

To run this pipeline, ensure the following:

* **Jenkins** instance with:

  * AWS credentials: `AWS_ACCESS_KEY_ID` & `AWS_SECRET_ACCESS_KEY`
  * SSH private key: `SSH_PRIVATE_KEY` (for remote EC2 access)
  * Slack API token: `SLACK_TOKEN`
* **Terraform** installed on the Jenkins agent.
* **AWS EC2 instances** accessible via SSH.



## ⚙️ Usage

1. In Jenkins, trigger the pipeline and select the desired `DEPLOY_OPTIONS`.
2. Monitor the console output for detailed stage logs.
3. View your Slack channel for instant deployment status updates.



## 📋 Pipeline Stages

1. **Initialise Terraform**
2. **Format & Validate Terraform Code** (`FMTVAL`)
3. **Plan & Apply Infrastructure** (`INFRA` or `ALL`)
4. **Destroy Infrastructure** (`DEL`)
5. **Deploy & Configure Applications** (`APPS` or `ALL`)
6. **Modify Nginx Port to 8080**
7. **Run Remote Tests with pytest**
8. **Send Slack Notifications**
9. **Clean Jenkins Workspace**

---

## 🛠 Best Practices Demonstrated

* **Separation of Concerns** via parameterised execution.
* **Infrastructure as Code** for reproducibility and version control.
* **Secure Credential Management** with Jenkins secrets.
* **Automated Testing** to catch issues early.
* **Continuous Feedback Loops** via Slack.
* **Environment Hygiene** through post-build cleanup.

---

## 📜 License

This project is released under the MIT License.
Here’s a practical integration of your original notes into a logically structured, recruiter-friendly README-style summary. It preserves all your content while enhancing clarity, coherence, and flow:

---

# 🛠️ Jenkins Provisioning Pipeline for Secure Cloud Automation and Remote App Deployment

## 📌 Project Summary

This project showcases a modular Jenkins pipeline designed for secure cloud provisioning, remote application deployment, and automated testing using **Terraform**, **SSH**, and **Slack notifications**. It demonstrates how Infrastructure as Code (IaC), CI/CD automation, and real-time feedback can be orchestrated to deliver scalable and maintainable cloud-native solutions.

---

## 🚀 Key Highlights

- **Modular Pipeline Design**  
  Built with six core stages:  
  1. Terraform Initialisation  
  2. Terraform Format & Validate  
  3. Terraform Plan  
  4. Terraform Apply  
  5. Nginx Installation  
  6. Python Installation  

- **Parameterised Execution via Jenkins UI**  
  Enables selective control of pipeline actions using `DEPLOY_OPTIONS`:
  - `apply` – Provision infrastructure and deploy apps  
  - `destroy` – Tear down infrastructure  
  - `ALL`, `INFRA`, `APPS`, `FMTVAL`, `DEL` – Enforce Separation of Concerns (SoC)

- **Secure Credential Management**  
  - AWS credentials (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`) injected via Jenkins UI  
  - SSH private key (`SSH_PRIVATE_KEY`) configured for remote EC2 access  
  - Slack token (`SLACK_TOKEN`) used for notification delivery

- **Infrastructure Provisioning with Terraform**  
  - Terraform configuration stored in the `dev` folder  
  - Provisions two EC2 instances:  
    - Node 1: Nginx  
    - Node 2: Python (Pynode)  
  - Outputs DNS values for remote access  
  - Supports destroy operation for resource cleanup

- **Application Deployment via SSH**  
  - Installs and configures Nginx and Python remotely  
  - Replaces Nginx config to listen on port 8080  
  - Deploys a Python script (`hello.py`) to `/tmp` on Pynode

- **Automated Testing**  
  - Executes `pytest` on the Python node to validate deployment  
  - Pipeline fails on test errors to ensure reliability

- **Slack Notifications**  
  - Sends success or failure messages to `devops-masterclass-2024` channel  
  - Uses secure token authentication  
  - Improves visibility and team communication

- **Post-Build Workspace Cleanup**  
  - Utilises Jenkins Workspace Cleanup plugin  
  - Ensures clean environment for future builds

---

## 📂 Repository Structure

```plaintext
.
├── Jenkinsfile               # Pipeline definition
├── dev/                     # Terraform configuration files
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfstate
├── hello.py                 # Python script deployed to Pynode
├── NG.conf                  # Custom Nginx configuration file
└── README.md                # Project documentation
```

---

## 🖥️ Jenkins Server Setup

- Hosted on a **Docker image** running on an **EC2 t2.small instance** (non-Free Tier)
- Jenkins plugins used:
  - `SSH Agent`
  - `Terraform`

---

## 📈 Best Practices Demonstrated

- Infrastructure as Code (IaC) with Terraform  
- Modular pipeline execution via parameters  
- Secure credential injection and remote access  
- Automated testing and validation  
- Real-time Slack notifications  
- Post-build cleanup for consistent environments

---

## 🎯 Recruiter-Friendly Project Title

> **Modular Jenkins Pipeline for Secure Cloud Provisioning, Remote App Deployment, and Slack-Integrated CI/CD Automation**

Would you like a matching GitHub description, portfolio summary, or diagram to visualise this pipeline? I can also help you turn this into a case study or interview talking point.

