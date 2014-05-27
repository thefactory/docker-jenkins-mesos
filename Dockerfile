# Jenkins with Mesos Plugin
#
# VERSION       1

FROM thefactory/mesos

MAINTAINER Mike Babineau mike@thefactory.com

# Get Jenkins
ADD http://mirrors.jenkins-ci.org/war/1.564/jenkins.war /opt/jenkins.war
RUN ln -sf /jenkins /root/.jenkins

# Install git
RUN apt-get -y install git

# Compile Mesos plugin
ADD https://github.com/jenkinsci/mesos-plugin/archive/mesos-0.3.0.zip /tmp/mesos-plugin.zip
RUN unzip /tmp/mesos-plugin.zip -d /opt && rm /tmp/mesos-plugin.zip
RUN ln -s /opt/mesos-plugin-mesos-0.3.0 /opt/mesos-plugin
RUN cd /opt/mesos-plugin && mvn package

# Install Mesos plugin (add to .war)
RUN python -c 'import zipfile,sys; zipfile.ZipFile(sys.argv[1],"a").write(sys.argv[2],sys.argv[3])' /opt/jenkins.war /opt/mesos-plugin/target/mesos.hpi WEB-INF/plugins/mesos.hpi

ENTRYPOINT ["java", "-jar", "/opt/jenkins.war"]
EXPOSE 8080
VOLUME ["/jenkins"]
CMD [""]