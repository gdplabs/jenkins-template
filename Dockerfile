FROM debian:wheezy

RUN echo "deb http://http.debian.net/debian wheezy-backports main" >> /etc/apt/sources.list && \
  apt-get update && apt-get install -y \
  curl \
  git \
  unzip \
  wget \
  zip \
  openjdk-7-jdk \
  ant \
  jq && \
  rm -rf /var/lib/apt/lists/* 

ENV JENKINS_HOME /var/jenkins_home
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV JAVA_OPTS -Dmail.smtp.starttls.enable=true

COPY php-qa.sh /usr/local/bin/php-qa.sh
RUN echo "deb http://packages.dotdeb.org wheezy-php56 all" > /etc/apt/sources.list.d/dotdeb.list && \
    curl http://www.dotdeb.org/dotdeb.gpg | apt-key add -

RUN apt-get update && apt-get install -y \
  php5-cli \
  php5-fpm \
  php5-dev \
  php5-mysql \
  php5-mcrypt \
  php5-gd \
  php5-curl \
  php-pear \
  && php-qa.sh

RUN useradd -d "$JENKINS_HOME" -u 1000 -m -s /bin/bash jenkins

RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d

COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy

ENV JENKINS_VERSION 1.596.1

RUN curl -L http://mirrors.jenkins-ci.org/war-stable/$JENKINS_VERSION/jenkins.war -o /usr/share/jenkins/jenkins.war

ENV JENKINS_UC https://updates.jenkins-ci.org
RUN chown -R jenkins "$JENKINS_HOME" /usr/share/jenkins/ref

COPY jenkins.sh /usr/local/bin/jenkins.sh
COPY plugins.sh /usr/local/bin/plugins.sh
COPY pluginslist.txt $JENKINS_HOME/pluginslist.txt
RUN plugins.sh $JENKINS_HOME/pluginslist.txt

VOLUME /var/jenkins_home
EXPOSE 8080
EXPOSE 50000
USER jenkins
ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
