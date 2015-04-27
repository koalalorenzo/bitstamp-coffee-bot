FROM node
ADD . /code
WORKDIR /code
RUN npm install grunt-cli -g
RUN npm install
RUN grunt build

CMD grunt tradeLoop
