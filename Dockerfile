FROM node:14 as demoapp
RUN mkdir -p /usr/app
WORKDIR /usr/app
COPY package*.json ./
RUN npm install 
COPY . .