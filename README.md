# bitstamp-coffee-bot
Example of a working Bitcoin trading bot for Bitstamp using NodeJS and CoffeeScript

After cloning the repository, install the dependencies and build the javascript:

    npm install
    grunt build

Then you are ready to run it to make one single trading session:

    grunt trade

If you want it to check bitstamp every 15 seconds, like a "real bot", you can also execute:

    grunt tradeLoop

### Notes from the Developer
I am not into trading, so this is just a basic bot that will check the transactions and perform buy/sell to try to earn something. I am a developer, not an economist-trader-broker-whatever... but feel free to improve the project to make it working!

I've created this project **for fun** and to experiment using NodeJS, CoffeeScript and Grunt and bitstamp APIs.
For your security, you can inspect the code: there is no strange withdrawal... but if you want to **donate** to keep me working on projects like this one, here is my Bitcoin address: *1GsAxo7aiuBkTAoUgb4ePWhUrBm9YW9cTq*

## Configuring
To configure correctly the program you need to create your own *config.json* file and put it inside the repository.
You can copy *config-example.json* into *config.json* and edit the file:

    cp ./config-example.json ./config.json

You will see something like that:

    {
      "key": "",
      "secret": "",
      "customer_id": "",
      "gap": 0.20,
      "fee": 0.25
    }

The properties *key, secret* and *customer_id* are Bitstamp values that you can generate from [this link](https://bitstamp.net/account/security/api/). Remember that the API authentication credential must allow the bot to trade, read transactions, balance and orders. Other permissions are not required since the bot will not perform withdrawals.

The property called *gap* is defining the difference between your last sell/buy. For example by using a value of 1.50, if you bought 1 BTC at 300 USD, he will sell 1 BTC for 301.50 and then try to buy that bitcoin, again for 300 USD, trying to earn 1.50 each time.

The property called *fee* is defining how much your trade will cost you, according to Bitstamp fees. I suggest to keep it as the maximum value that is *0.25*. [Read more here](https://www.bitstamp.net/fee_schedule/)

## Running using Docker

You can also run the trade bot, in its loop version, using Docker. To build the docker container and start the infinite loop:

    docker build -t trader .
    docker run trader

Remember that to kill the container, you will need to run *docker kill* with the container ID.
