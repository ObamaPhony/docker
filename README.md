# Docker image for the ObamaPhony project

## How to use this `Dockerfile`

```
git clone https://github.com/ObamaPhony/docker.git ObamaPhony
cd ObamaPhony
docker build -t obamaphony:latest . # build the Docker image
docker pull mongo:latest
docker run --name obamamongo -d mongo # backend MongoDB container
docker run --name obamaphony --link obamamongo:mongo obamaphony
```
