## Cribl Assignment
### Sample application 

Project structure:
```
.
├── docker-compose.yaml*
├── docker-compose-benchmark.yaml
├── source
│   ├── Dockerfile
│   └── entrypoint.sh 
├── agent
│   ├── inputs
│   │   ├── large_1M_events.log
│   ├── app.json
│   ├── inputs.json
│   └── output.json
├── splitter
│   ├── app.json
│   ├── filter.json
│   ├── inputs.json
│   └── outputs.json
├── target
│   ├── app.json
│   ├── inputs.json
│   ├── outputs.json
├── app.js
├── app.ts
├── package-lock.json
├── Dockerfile
├── test.py
└── run.sh
```

[_Dockerfile_](Dockerfile)
```
FROM node:14 as demoapp
RUN mkdir -p /usr/app
WORKDIR /usr/app
COPY package*.json ./
RUN npm install 
COPY . .
```
The Dockerfile create a general image for the services

[_docker-compose.yaml_](docker-compose.yaml)
```
version: '3.8'
services:
  target_1:
    build: .
    expose:
      - 9997
    command: node app.js target
  target_2:
    build: .
    expose:
      - 9997
    command: node app.js target
  splitter:
    build: .
    expose:
      - 9997
    depends_on:
      - target_1
      - target_2
    command: node app.js splitter
  agent:
    build: .
    depends_on:
      - splitter
    command: node app.js agent
```
The docker compose file defines services: `agent`, `splitter`, `target_1` and `target_2` and run the services

[_docker-compose-benchmark.yaml_](docker-compose-benchmark.yaml)
```
version: '3.7'
services:
  source:
    depends_on:
      - splitter
    build:
      context: ./source/
    volumes:
      - "./agent/inputs:/data/"
  target_1:
    build: .
    expose:
      - 9997
    command: node app.js target
  target_2:
    build: .
    expose:
      - 9997
    command: node app.js target
  splitter:
    build: .
    expose:
      - 9997
    depends_on:
      - target_1
      - target_2
    command: node app.js splitter
```
The docker-compose-benchmark.yml file creates a source container that exsercie spliiter (based on [Cribl benchmark](https://github.com/criblio/benchmark) )

## Deploy with docker-compose 

```
$ docker-compose up -d 
```

## Correctness: validate data sent/received is correct
[_test.py_](test.py)
There are two test cases created using python unittest to verify the input and output
test case 1:
Verify the checksum of the two files
test case 2:
Compare each line until there is a difference 

To run the test:
```
$ python test.py input output
```
## Performance 
A bash script [_run.sh_](run.sh) is used to 
1. set up the environment.
2. copy events logs to local.
3. run input/output validation python on local using target events logs. 
4. The script measures the agent process running time as basic performance evaluation of the throughput. 
5. Few benchmarks:
Attempt | 6M row | 8M row | 10M row | 12M row | 15M row |
--- | --- | --- | --- | --- | --- |
Seconds | 2s | 3s | 3s | 4s | 5s |
6. tear down application
   
to run the script
```
./run.sh
```

##Issues:
1. I am not able to get the agent container performance metrics such as CPU and memory. I want to utilze 'docker stats' to get the info. But the container exit pretty fast.
2. The CI/CD is not implemented as required, but using bash to do the deploy test, teardown.
3. I could create Dockerfile under each service instead of creating a general image for all.