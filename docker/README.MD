## How-to run Docker container

### Prerequisities:
-  Docker 20.04+ is installed
-  OpenBoxes database (and db user) is already set-up
-  Grails 3 is installed (e.g. with SDK Man)

### Instructions:

**Note**: Run the below commands in **main** project directory.


1. Run grails build to produce executable openboxes.war file. This WAR file contains embedded Tomcat.
`grails prod war`
2. Prepare docker build with gradle. It copies war and configuration files to *build/docker*.
`./gradlew prepareDocker`
3. Build a docker image:
`docker build --tag="openboxes/openboxes:latest" build/docker/`
4. Once built you can spin up a container of the image in a few ways:
####	Custom settings
Edit the default environment variables for database connection (*DB_HOST*, *DB_PORT*, *DB_PASSWORD*, *DB_PASSWORD*) and other settings in `docker/.env`. Then run container with:

`docker run --env-file=docker/.env -p 8080:8080 --name=openboxes openboxes/openboxes:latest`

Openboxes app will be reachable at localhost:8080/openboxes once database initalizes.
#### Persistable Logs
If you'd like the application logs to be persistable (after removing the container) run the docker with *journald* agent.

  `docker run --env-file=docker/.env -p 8080:8080 --name=openboxes --log-driver=journald openboxes/openboxes:latest`

The logs can be accessed with:

`journalctl -u docker CONTAINER_NAME=openboxes`
####	Run with default configuration.
By default Openboxes container will try to connect to host's MySQL server (works with Docker 20.04+). You have to set bind.address=0.0.0.0 in MySQL configuration, and have a default `openboxes` database user.

`docker  run -p 8080:8080 --name=openboxes --add-host host.docker.internal:host-gateway openboxes/openboxes:latest`
