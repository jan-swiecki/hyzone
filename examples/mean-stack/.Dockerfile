FROM ubuntu:14.04
RUN mkdir -p /opt/installers
WORKDIR /opt/installers
COPY installers/node.sh /opt/installers
RUN /opt/installers/node.sh
COPY installers/python.sh /opt/installers
RUN /opt/installers/python.sh
RUN npm install -g browserify
RUN npm install -g wzrd
RUN pip install awscli
