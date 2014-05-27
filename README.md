Runs a [Jenkins](http://jenkins-ci.org/) instance with the [Mesos plugin](https://github.com/jenkinsci/mesos-plugin) installed.

Available on the Docker Index as [thefactory/jenkins-mesos](https://index.docker.io/u/thefactory/jenkins-mesos/):

    docker pull thefactory/jenkins-mesos

### Versions
* Jenkins 1.564
* Mesos plugin 0.3.0
* Mesos 0.18.2

### Usage
Launch the container with a volume passed in at `/jenkins`. For the Mesos plugin to register with the Mesos cluster, you will need to enable host networking with `--net=host` (available in Docker 0.11+, see [announcement](http://blog.docker.io/2014/05/docker-0-11-release-candidate-for-1-0/))

Starting the container:

    docker run \
        --net=host \
        -p 8080:8080 \
        -v /var/lib/jenkins:/jenkins \
        thefactory/jenkins-mesos:latest

Once the container is up, visit `http://<host>:8080/` and confirm Jenkins starts properly.

To configure the Mesos plugin, go to the Jenkins configuration page (`http://<host>:8080/configure`). At the bottom, click "Add a new cloud" and fill in the required settings. Set _Mesos native library path_ to `/usr/local/lib/libmesos.so`.

You can read more about configuration and usage of the Mesos plugin [here](https://github.com/jenkinsci/mesos-plugin/blob/master/README.md).