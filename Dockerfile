FROM debian:jessie

RUN echo "deb http://http.debian.net/debian wheezy-backports main" >> /etc/apt/sources.list && \
  apt-get update && apt-get install -y \
  curl \
  git \
  unzip \
  wget \
  zip \
  bzip2 \
  openjdk-7-jdk \
  ant \
  fontconfig \
  libfreetype6 \
  libicu52 \
  jq && \
  rm -rf /var/lib/apt/lists/* 

ENV JENKINS_HOME /var/jenkins_home
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV JAVA_OPTS -Dmail.smtp.starttls.enable=true
ENV JENKINS_VERSION 1.596.3
ENV JENKINS_UC https://updates.jenkins-ci.org

COPY php-qa.sh /usr/local/bin/php-qa.sh
RUN apt-get update && apt-get install -y \
    php5-cli \
    php5-fpm \
    php5-dev \
    php5-mysql \
    php5-mcrypt \
    php5-gd \
    php5-curl \
    php-pear && \
    chmod +x /usr/local/bin/php-qa.sh && \
    php-qa.sh && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -d "$JENKINS_HOME" -u 1000 -m -s /bin/bash jenkins && \
    mkdir -p /usr/share/jenkins/ref/init.groovy.d && \
    curl -L http://mirrors.jenkins-ci.org/war-stable/$JENKINS_VERSION/jenkins.war -o /usr/share/jenkins/jenkins.war
COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy
RUN chown -R jenkins "$JENKINS_HOME" /usr/share/jenkins/ref

COPY jenkins.sh /usr/local/bin/jenkins.sh
COPY plugins.sh /usr/local/bin/plugins.sh
COPY pluginslist.txt $JENKINS_HOME/pluginslist.txt
RUN chmod +x /usr/local/bin/jenkins.sh && \
    chmod +x /usr/local/bin/plugins.sh && \
    plugins.sh $JENKINS_HOME/pluginslist.txt

VOLUME /var/jenkins_home
EXPOSE 8080
EXPOSE 50000
USER jenkins
ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
