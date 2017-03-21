FROM ruby:2.3@sha256:d7db5c56fd396249530304acac81e1c99ba82b9c0f81928f1a2fa6a0e5d63a0d
WORKDIR /usr/local/
RUN wget https://nodejs.org/dist/v6.9.1/node-v6.9.1-linux-x64.tar.xz
RUN tar -xf node-v6.9.1-linux-x64.tar.xz
ENV PATH "$PATH:/usr/local/node-v6.9.1-linux-x64/bin/"
RUN npm install -g yarn