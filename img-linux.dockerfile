#
# Container Image Gitora
#

ARG TOMCAT_IMG

FROM ${TOMCAT_IMG}

ARG PROJ_NAME
ARG PROJ_VERSION
ARG PROJ_BUILD_NUM
ARG PROJ_BUILD_DATE
ARG PROJ_REPO
ARG FACES_VERSION

LABEL org.opencontainers.image.authors="V10 Solutions"
LABEL org.opencontainers.image.title="${PROJ_NAME}"
LABEL org.opencontainers.image.version="${PROJ_VERSION}"
LABEL org.opencontainers.image.revision="${PROJ_BUILD_NUM}"
LABEL org.opencontainers.image.created="${PROJ_BUILD_DATE}"
LABEL org.opencontainers.image.description="Container image for Gitora"
LABEL org.opencontainers.image.source="${PROJ_REPO}"

RUN apk add --no-cache "git"

WORKDIR "${CATALINA_HOME}"

RUN rm -rf "webapps" \
	&& mkdir "webapps"

WORKDIR "/tmp"

RUN curl -L -f -o "faces.jar" "https://maven.java.net/content/repositories/releases/org/glassfish/javax.faces/${FACES_VERSION}/javax.faces-${FACES_VERSION}.jar" \
	&& mv "faces.jar" "/opt/tomcat/lib/"

RUN PROJ_VERSION_PARTS=(${PROJ_VERSION//\./ }) \
	&& curl -L -f -o "gitora.zip" "https://gitora.com/resources/downloads/gitora_${PROJ_VERSION_PARTS[0]}_${PROJ_VERSION_PARTS[1]}_trial_build_19_06_17_2022.zip" \
	&& unzip "gitora.zip" \
	&& mv "gitora/apache-tomcat-"*"/webapps/gitora" "${CATALINA_HOME}/webapps/" \
	&& mv "gitora/apache-tomcat-"*"/webapps/gitblit" "${CATALINA_HOME}/webapps/" \
	&& rm "gitora.zip"

WORKDIR "${CATALINA_HOME}"

RUN chmod "700" "webapps" \
	&& chown -R "480":"480" "webapps" \
	&& mkdir -p "data/gitblit" "data/gitora" "data/repositories" \
	&& chmod "700" "data" \
	&& chown -R "480":"480" "data"

WORKDIR "/"
