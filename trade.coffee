moment = require 'moment'
storage = require 'node-persist'
fs = require "fs"
Bitstamp = require 'bitstamp'

Account = require './account.js'
config = require './config.json'

publicBitstamp = new Bitstamp
account = new Account
moment().format()

price =
  usd_per_btc: 0.0
  date: new Date()


trade = (callback) ->
  console.log "--- Start Session: " + new Date
  publicBitstamp.ticker (a, ticker) ->
    avarage = (parseFloat(ticker.ask) + parseFloat(ticker.bid)) / 2
    price.usd_per_btc = avarage
    price.date = new Date
    console.log "Current price: #{avarage}"

    account.load ->
      if account.balance.btc <= 0 and account.balance.usd <= 0
        console.log "No money on the account! :("
      else if(account.orders.length > 0)
        console.log "There are some Open Orders... waiting"
      else
        for element in account.transactions
          element.btc = parseFloat element.btc
          element.usd = parseFloat element.usd
          element.btc_usd = parseFloat element.btc_usd

          if not most_recent_order
            most_recent_order = element
            most_recent_datetime = moment element.datetime
            break

          element_datetime = moment element.datetime
          if element_datetime < most_recent_datetime
            most_recent_order = element
            most_recent_datetime = moment element.datetime

        if most_recent_order.type is "buy"
          # You bought now SELL

          selling_price = most_recent_order.btc_usd + config.gap
          current_selling_price = price.usd_per_btc + config.gap
          if selling_price < current_selling_price
            selling_price = current_selling_price

          account.sell account.balance.btc, selling_price

        else
          # You sold now BUY!
          buying_price = most_recent_order.btc_usd - config.gap
          current_buying_price = price.usd_per_btc - config.gap
          if buying_price > current_buying_price
            buying_price = current_buying_price

          amount_of_btc_to_buy = account.balance.usd / buying_price
          __big_amount = parseInt amount_of_btc_to_buy*10000
          amount_of_btc_to_buy = parseFloat(__big_amount) /10000
          account.buy amount_of_btc_to_buy, buying_price

      setTimeout ->
        console.log "--- End Session: " + new Date
        account.save callback
      , 750

module.exports = trade
