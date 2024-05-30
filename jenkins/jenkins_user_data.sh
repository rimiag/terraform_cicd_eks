#!/bin/bash

# Update and install dependencies
apt-get update -y
apt-get install -y apt-transport-https ca-certificates curl gnupg software-properties-common

# Install Jenkins
# Add the Jenkins repository
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

sh -c 'echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# Update package list and install Jenkins
apt-get update -y
apt-get install -y jenkins
sudo apt install fontconfig openjdk-17-jre -y
# Start Jenkins service
systemctl start jenkins
systemctl enable jenkins

# Install Terraform
# Add the HashiCorp GPG key
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -

# Add the HashiCorp repository
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# Update package list and install Terraform
apt-get update -y
apt-get install -y terraform

# Install kubectl
# Download the latest release of kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Install kubectl
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Verify installations
echo "Verifying installations..."
echo "Jenkins version:"
systemctl status jenkins | grep Active
echo "Terraform version:"
terraform -version
echo "kubectl version:"
kubectl version --client

# Clean up
rm kubectl

