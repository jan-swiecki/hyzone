FROM java:8
MAINTAINER Jan Święcki <jan.swiecki@gmail.com>

RUN mkdir -p /opt/app
WORKDIR /opt/app

COPY App.java /opt/app/App.java

RUN javac App.java