#!/bin/bash

# Update system packages
sudo yum update -y

# Add Jenkins repository
sudo wget -O /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/redhat-stable/jenkins.repo

# Import Jenkins GPG key
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Upgrade packages
sudo yum upgrade -y

# Install latest Amazon Corretto Java (Java 21 LTS)
sudo yum install java-21-amazon-corretto -y

# Verify Java version
java -version

# Install Jenkins and Git
sudo yum install jenkins git -y

# Reload systemd
sudo systemctl daemon-reload

# Enable and start Jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Check Jenkins service status
sudo systemctl status jenkins --no-pager

# Create alternate temp directory
sudo mkdir -p /var/tmp_disk

# Set proper permissions
sudo chmod 1777 /var/tmp_disk

# Bind mount /tmp to new location
sudo mount --bind /var/tmp_disk /tmp

# Persist mount after reboot
echo '/var/tmp_disk /tmp none bind 0 0' | sudo tee -a /etc/fstab

# Prevent system tmp.mount conflicts
sudo systemctl mask tmp.mount

# Verify mount
df -h /tmp

# Restart Jenkins after temp mount change
sudo systemctl restart jenkins

# Check Jenkins final status
sudo systemctl status jenkins --no-pager

# Get initial admin password
echo "Jenkins Initial Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

sudo mkdir -p /var/tmp_disk
sudo chmod 1777 /var/tmp_disk
sudo mount --bind /var/tmp_disk /tmp
echo '/var/tmp_disk /tmp none bind 0 0' | sudo tee -a /etc/fstab
sudo systemctl mask tmp.mount
df -h /tmp
sudo systemctl restart jenkins
