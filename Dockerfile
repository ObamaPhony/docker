FROM alpine:3.4

RUN echo '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories

RUN apk add --no-cache git nodejs python py-pip g++ make py-numpy@testing
RUN pip install nltk

ARG USER=docker
ARG HOME=/home/$USER

RUN addgroup -S $USER \
 && adduser -h $HOME -S $USER \
 && adduser $USER $USER

RUN git clone https://github.com/ObamaPhony/node-app.git         $HOME/app
RUN git clone https://github.com/ObamaPhony/speech-analysis.git  $HOME/analysis
RUN git clone https://github.com/ObamaPhony/speech-generator.git $HOME/generator
RUN ln -s ../analysis/speech-analysis.py   $HOME/app/bin/analyse
RUN ln -s ../generator/speech-generator.py $HOME/app/bin/generate

WORKDIR $HOME/app
RUN npm install --production

RUN apk del --no-cache git py-pip g++ make
RUN rm -rf ~/.cache ~/.npm ~/.node-gyp

RUN chown -R $USER:$USER $HOME/app
USER $USER

EXPOSE 8080
CMD ["npm", "start"]
