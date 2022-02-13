FROM node:14 as demoapp
RUN mkdir -p /usr/app
WORKDIR /usr/app
COPY package*.json ./
RUN npm install \
    apt update \
    apt install less
COPY . .
CMD ["sleep","60"]