# Jenkins Template

This docker image contains preinstalled Jenkins with necessarry plugins to build php and java project. Installed plugins can be seen inside **pluginlists.txt**. To add another plugins, put plugin name inside the file. This images is also preinstalled with necesarry php qa tools that can be found at **php-qa.sh**. Jenkins version is determinated by _JENKINS_VERSION_ variable inside **Dockerfile**, currently set to 1.596.3

# How to use this image?
To create a container from this image, execute `docker run gdplabs/jenkins-template`. The container is using port 8080 for jenkins web interface, and port 50000 for slave agent. Jenkins home is set to **/var/jenkins_home**. It is advised to mount volume to jenkins home either using volume container or host directory in order to preserve jenkins data.
