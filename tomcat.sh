#!/bin/bash

# Install Java 17
sudo yum install java-17-amazon-corretto -y

# Verify Java
java -version

# Download Tomcat 9
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.112/bin/apache-tomcat-9.0.112.tar.gz

# Extract Tomcat
tar -xvzf apache-tomcat-9.0.112.tar.gz

# Configure manager user
sed -i '/<\/tomcat-users>/i \
<role rolename="manager-gui"/>\
<role rolename="manager-script"/>\
<user username="tomcat" password="admin@123" roles="manager-gui,manager-script"/>' \
apache-tomcat-9.0.112/conf/tomcat-users.xml

# Remove RemoteAddrValve restriction dynamically
sed -i '/RemoteAddrValve/d' apache-tomcat-9.0.112/webapps/manager/META-INF/context.xml
sed -i '/allow=/d' apache-tomcat-9.0.112/webapps/manager/META-INF/context.xml

# Permissions
chmod +x apache-tomcat-9.0.112/bin/*.sh

# Start Tomcat
sh apache-tomcat-9.0.112/bin/startup.sh

# Verify
ps -ef | grep tomcat
ss -tulnp | grep 8080
