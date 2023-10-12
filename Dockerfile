FROM alpine:3.18

RUN echo '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories \
    && apk add --no-cache git nodejs npm python3 g++ make \
    && python3 -m ensurepip \
    && pip3 install --upgrade pip setuptools \
    && pip3 install nltk

ENV USERNAME docker

RUN addgroup -S $USERNAME \
 && adduser -S $USERNAME \
 && adduser $USERNAME $USERNAME

RUN git clone https://github.com/ObamaPhony/node-app.git /docker/app \
    && git clone https://github.com/ObamaPhony/speech-analysis.git /docker/analysis \
    && git clone https://github.com/ObamaPhony/speech-generator.git /docker/generator

RUN ln -s /docker/analysis/analyse-speeches.py /docker/app/bin/analyse \
    && ln -s /docker/generator/speech-generator.py /docker/app/bin/generate

WORKDIR /docker/app
RUN npm install --production

RUN apk del --no-cache --rdepends git g++ make py3-pip \
  && chown -Rv $USERNAME:$USERNAME /docker
USER $USERNAME

# Download NLTK stuff.
RUN python3 -c \
    'import nltk; nltk.download("punkt"); nltk.download("averaged_perceptron_tagger")'

EXPOSE 8080
CMD ["npm", "start"]
