# Jenkins with Mesos Plugin
#
# VERSION       1

FROM debian:wheezy

MAINTAINER Mike Babineau mike@thefactory.com

# Update package list
RUN apt-get update

# Install Java and maven
RUN apt-get -y install openjdk-7-jdk maven
RUN ln -s /usr/lib/jvm/java-1.7.0-openjdk-amd64/jre/lib/amd64/server/libjvm.so /usr/lib/libjvm.so

# Get Jenkins
ADD http://mirrors.jenkins-ci.org/war/1.564/jenkins.war /opt/jenkins.war
RUN ln -sf /jenkins /root/.jenkins

## Compile Mesos plugin
ADD https://github.com/jenkinsci/mesos-plugin/archive/mesos-0.3.0.zip /tmp/mesos-plugin.zip
RUN unzip /tmp/mesos-plugin.zip -d /opt && rm /tmp/mesos-plugin.zip
RUN ln -s /opt/mesos-plugin-mesos-0.3.0 /opt/mesos-plugin
RUN cd /opt/mesos-plugin && mvn package

# Install Mesos plugin (add to .war)
RUN python -c 'import zipfile,sys; zipfile.ZipFile(sys.argv[1],"a").write(sys.argv[2],sys.argv[3])' /opt/jenkins.war /opt/mesos-plugin/target/mesos.hpi WEB-INF/plugins/mesos.hpi

# Install Mesos (for native library)
RUN apt-get -y install curl
ADD http://downloads.mesosphere.io/master/debian/7/mesos_0.18.2_amd64.deb /tmp/mesos.deb
RUN dpkg -i /tmp/mesos.deb && rm /tmp/mesos.deb

ENTRYPOINT ["java", "-jar", "/opt/jenkins.war"]
EXPOSE 8080
VOLUME ["/jenkins"]
CMD [""]