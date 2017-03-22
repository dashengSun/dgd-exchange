FROM ruby:2.3@sha256:ec48e0d4d9cd74c56ce659b20d09346ed1294d5621913d69782a53fc472529e8
WORKDIR /usr/local/
RUN wget https://nodejs.org/dist/v6.9.1/node-v6.9.1-linux-x64.tar.xz
RUN tar -xf node-v6.9.1-linux-x64.tar.xz
ENV PATH "$PATH:/usr/local/node-v6.9.1-linux-x64/bin/"
RUN npm install -g yarn