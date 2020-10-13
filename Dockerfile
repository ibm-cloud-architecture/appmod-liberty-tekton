FROM maven:3.6.0-jdk-8-slim AS build-stage
COPY . /project
WORKDIR /project/CustomerOrderServicesProject
RUN mvn clean package
  
FROM ibmcom/websphere-liberty:kernel-java8-ibmjava-ubi
 
ARG SSL=false
ARG MP_MONITORING=false
ARG HTTP_ENDPOINT=false
 
COPY --chown=1001:0 ./liberty/server.xml /config/server.xml
COPY --chown=1001:0 ./liberty/jvm.options /config/jvm.options
COPY --chown=1001:0 --from=build-stage /project/CustomerOrderServicesApp/target/CustomerOrderServicesApp-0.1.0-SNAPSHOT.ear /config/apps/CustomerOrderServicesApp-0.1.0-SNAPSHOT.ear
COPY --chown=1001:0 ./resources/ /opt/ibm/wlp/usr/shared/resources/

RUN configure.sh

