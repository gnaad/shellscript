#!/bin/bash

set -e

JENKINS_VERSION="2.479.3"
INSTALL_DIR="/app/jenkins"
LOGS_DIR="$INSTALL_DIR/logs"
JENKINS_WAR="$INSTALL_DIR/jenkins.war"
DOWNLOAD_URL="https://get.jenkins.io/war-stable/${JENKINS_VERSION}/jenkins.war"

echo "Updating & Upgrading Ubuntu"
sudo apt update && sudo apt upgrade -y --ignore-missing

echo "Installing OpenJDK 21"
sudo apt install openjdk-21-jdk -y

echo "Creating Jenkins and log directory"
mkdir -p "$INSTALL_DIR" "$LOGS_DIR"

echo "Navigating to Jenkins directory"
cd "$INSTALL_DIR"

echo "Downloading Jenkins WAR of version $JENKINS_VERSION"
curl -L -o "$JENKINS_WAR" "$DOWNLOAD_URL"

chmod +x "$JENKINS_WAR"

echo "Jenkins installation completed at: $INSTALL_DIR"

echo "Starting Jenkins"
java -jar "$JENKINS_WAR" > "$LOGS_DIR/jenkins.log" 2>&1 &
echo "Jenkins started"

echo "Installing UFW"
sudo apt install ufw

echo "Making 8080 port accessible"
sudo ufw allow 8080/tcp

echo "Reloading firewall"
sudo ufw --force enable

echo "Status of firewall"
sudo ufw status
