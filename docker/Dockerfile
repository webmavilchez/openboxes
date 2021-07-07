FROM openjdk:8u292-jre-slim-buster

LABEL maintainer="support@openboxes.com"
EXPOSE 8080
ENV JAVA_TOOL_OPTIONS="-Xms1024m -Xmx1024m -XX:+UseParallelGC -Djava.awt.headless=true"

# Create openboxes user and group
RUN useradd --user-group --shell /bin/false  --home-dir /app openboxes
WORKDIR /app

# Copy and chown the war and configuration files
COPY --chown=openboxes:openboxes openboxes.war openboxes.war
COPY --chown=openboxes:openboxes openboxes.yml /app/.grails/

USER openboxes
CMD ["java","-Dgrails.env=prod","-jar","/app/openboxes.war"]
