FROM jenkins/jenkins

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV JENKINS_USER admin
ENV JENKINS_PASS admin

USER root
RUN groupadd docker

RUN ssh-keygen -f /root/.ssh/id_rsa -t rsa -N ''

#Set the new plugins list
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Installing Docker
RUN apt-get update && apt-get install -y apt-transport-https \
       ca-certificates curl gnupg2 wget jq git vim \
       software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) stable"
RUN apt-get update && apt-get install -y docker-ce-cli

# Compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

# Set up user
COPY setup_jenkins.groovy /usr/share/jenkins/ref/init.groovy.d/

# Copy useful files for configuration
COPY token_credentials.sh /bin/bash
COPY scanner_conf.sh /bin/bash