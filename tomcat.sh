#!/bin/bash

# Update packages
sudo yum update -y

# Install Java 17
sudo yum install java-17-amazon-corretto -y

# Verify Java
java -version

# Download Apache Tomcat 9
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.112/bin/apache-tomcat-9.0.112.tar.gz

# Extract Tomcat
tar -xvzf apache-tomcat-9.0.112.tar.gz

# Configure Tomcat manager user
cat <<EOF >> apache-tomcat-9.0.112/conf/tomcat-users.xml

<role rolename="manager-gui"/>
<role rolename="manager-script"/>
<role rolename="admin-gui"/>

<user username="tomcat" password="admin@123"
roles="manager-gui,manager-script,admin-gui"/>

EOF

# Configure manager app remote access
cat <<EOF > apache-tomcat-9.0.112/webapps/manager/META-INF/context.xml
<Context antiResourceLocking="false" privileged="true">
</Context>
EOF

# Configure host-manager remote access
cat <<EOF > apache-tomcat-9.0.112/webapps/host-manager/META-INF/context.xml
<Context antiResourceLocking="false" privileged="true">
</Context>
EOF

# Give execute permissions
chmod +x apache-tomcat-9.0.112/bin/*.sh

# Start Tomcat
sh apache-tomcat-9.0.112/bin/startup.sh

# Verify Tomcat
ps -ef | grep tomcat
ss -tulnp | grep 8080


echo "Tomcat URL: http://<server-ip>:8080"
echo "Manager URL: http://<server-ip>:8080/manager/html"
echo "Username: tomcat"
echo "Password: admin@123"
