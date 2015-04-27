storage = require 'node-persist'

Bitstamp = require 'bitstamp'
config = require './config.json'
storage.initSync()

privateBitstamp = new Bitstamp config.key, config.secret, config.customer_id


class Account

  constructor: ->
    @balance =
      btc: 0.0
      usd: 0.0
    @last_update = new Date()
    @transactions = []
    @orders = []

  save: ->
    storage.setItem 'balance', @balance
    storage.setItem 'last_update', @last_update
    storage.setItem 'transactions', @transactions
    storage.setItem 'orders', @orders
    @

  load: (callback=no) ->
    @balance = storage.getItem 'balance'
    @last_update = storage.getItem 'last_update'
    @transactions = storage.getItem 'transactions'
    @orders = storage.getItem 'orders'

    @update_balance =>
      @update_orders =>
        @update_transactions ->
          callback @ if callback
    @

  update_balance: (callback) ->
    privateBitstamp.balance (a, b) =>
      balance =
        btc: parseFloat b.btc_available
        btc_reserved: parseFloat b.usd_reserved
        usd: parseFloat b.usd_available
        usd_reserved: parseFloat b.usd_reserved

      @balance = balance
      callback(balance) if(callback)
    @

  update_transactions : (callback) ->
    privateBitstamp.user_transactions 5, (a, b) =>
      trading_transactions = []
      for element in b when element.type is not 2

        if parseFloat(element.usd) < 0
          element.type = "buy"
        if parseFloat(element.btc) < 0
          element.type = "sell"

        trading_transactions.push element

      @transactions = trading_transactions
      callback trading_transactions if(callback)
    @

  update_orders : (callback) ->
    privateBitstamp.open_orders (a, b) =>
      @orders = b
      callback(b) if(callback)

  buy : (amount, price, callback) ->
    # 1 BTC : price USD = amount BTC : earning USD
    earnings = price * amount
    real_earnings = earnings - (earnings * config.fee)
    privateBitstamp.buy amount, price, (a, b) ->
      console.log "Buy #{amount} BTC at #{price} = #{real_earnings} USD"
      callback @ if(callback)
    @


  sell : (amount, price, callback) ->
    # 1 BTC : price USD = amount BTC : earning USD
    earnings = price * amount
    # The minimum is 5 Dollars.
    return if earnings < 5

    real_earnings = earnings - (earnings * config.fee)
    privateBitstamp.sell amount, price, (a, b) =>
      console.log "Sell #{b.amount} BTC at #{b.price} = #{real_earnings} USD"
      callback(@) if(callback)
    @


  calculate_earnings : (price, amount) ->
    earnings_usd = (price * amount) - ((price - config.gap) * amount)
    fees = earnings_usd * config.fee
    earnings_usd - fees

module.exports = Account
