require 'sinatra'
require 'json'
require 'httparty'
require_relative 'app/repositories/yunbi_api'
require_relative 'app/repositories/bittrex_api'

ENVIRONMENT = {API_ENDPOINT: ENV['API_ENDPOINT']}
DGD_EXCHANGE_URL = '/exchange'

get "#{DGD_EXCHANGE_URL}/new/?" do
  erb exchange(:index)
end

get "#{DGD_EXCHANGE_URL}/refresh/?" do
  market_response = call_market_api
  order_book_response = call_order_book_api

  market_data(market_response) + "\n" + order_book_data(order_book_response)
end

error 400 do
  erb :error
end

not_found do
  logger.error "error occurs: #{env['sinatra.error'].message}"
  erb :error
end

# :nocov:
error do
  logger.error "error occurs: #{env['sinatra.error'].message}\n#{env['sinatra.error'].backtrace.join("\n")}"
  erb :error
end
# :nocov:

private

def exchange template
  "#{DGD_EXCHANGE_URL}/#{template}".to_sym
end

def error_response(error)
  status 500
  raise error
end

def call_market_api
  yunbi_dgd = YunbiApi.new.fetch_market_exchange('dgdcny')
  yunbi_eth = YunbiApi.new.fetch_market_exchange('ethcny')

  bittrex_dgd = BittrexApi.new.fetch_market_exchange('BTC-DGD')
  bittrex_eth = BittrexApi.new.fetch_market_exchange('BTC-ETH')

  puts yunbi_dgd
  puts yunbi_eth
  puts bittrex_dgd
  puts bittrex_eth
  {
    :yunbi_dgd => yunbi_dgd,
    :yunbi_eth => yunbi_eth,
    :bittrex_dgd => bittrex_dgd,
    :bittrex_eth => bittrex_eth
  }
end

def call_order_book_api
  yunbi_dgd_order_book = YunbiApi.new.fetch_order_book('dgdcny')
  yunbi_eth_order_book = YunbiApi.new.fetch_order_book('ethcny')

  bittrex_dgd_order_book = BittrexApi.new.fetch_order_book('BTC-DGD')
  bittrex_eth_order_book = BittrexApi.new.fetch_order_book('BTC-ETH')
  {
    :yunbi_dgd_order_book => yunbi_dgd_order_book,
    :yunbi_eth_order_book => yunbi_eth_order_book,
    :bittrex_dgd_order_book => bittrex_dgd_order_book['result'],
    :bittrex_eth_order_book => bittrex_eth_order_book['result']
  }
end

def calculate_average_price(order_book, volume, type, volume_field_name, price_field_name)
  count = 0
  volume_total_price = 0
  order_book[type].each do |order|
    if count < volume
      if count + order[volume_field_name].to_f > volume
        volume_total_price += (volume - count) * order[price_field_name].to_f
        count = volume
      else
        count += order[volume_field_name].to_f
        volume_total_price += order[volume_field_name].to_f * order[price_field_name].to_f
      end
    end
  end
  volume_total_price / count
end

def market_data(response)
  yunbi_dgd_bid = response[:yunbi_dgd]['ticker']['buy']
  yunbi_dgd_ask = response[:yunbi_dgd]['ticker']['sell']

  yunbi_eth_bid = response[:yunbi_eth]['ticker']['buy']
  yunbi_eth_ask = response[:yunbi_eth]['ticker']['sell']

  bittrex_dgd_bid = response[:bittrex_dgd]['result']['Bid']
  bittrex_dgd_ask = response[:bittrex_dgd]['result']['Ask']

  bittrex_eth_bid = response[:bittrex_eth]['result']['Bid']
  bittrex_eth_ask = response[:bittrex_eth]['result']['Ask']

  yunbi_dgd_eth_buy = (yunbi_dgd_ask.to_f / yunbi_eth_bid.to_f).round(6)
  yunbi_dgd_eth_sell = (yunbi_dgd_bid.to_f / yunbi_eth_ask.to_f).round(6)

  bittrex_dgd_eth_buy = (bittrex_dgd_ask.to_f / bittrex_eth_bid.to_f).round(6)
  bittrex_dgd_eth_sell = (bittrex_dgd_bid.to_f / bittrex_eth_ask.to_f).round(6)

  "yunbi买价: #{yunbi_dgd_eth_buy}, yunbi卖价: #{yunbi_dgd_eth_sell}" + "\n" +
    "bittrex买价: #{bittrex_dgd_eth_buy}, bittrex卖价: #{bittrex_dgd_eth_sell}"
end

def order_book_data response
  yunbi_dgd_average_100_ask = calculate_average_price(response[:yunbi_dgd_order_book], 100, 'asks', 'remaining_volume', 'price')
  yunbi_dgd_average_100_bid = calculate_average_price(response[:yunbi_dgd_order_book], 100, 'bids', 'remaining_volume', 'price')

  yunbi_eth_average_100_ask = calculate_average_price(response[:yunbi_eth_order_book], 100, 'asks', 'remaining_volume', 'price')
  yunbi_eth_average_100_bid = calculate_average_price(response[:yunbi_eth_order_book], 100, 'bids', 'remaining_volume', 'price')

  bittrex_dgd_average_100_ask = calculate_average_price(response[:bittrex_dgd_order_book], 100, 'sell', 'Quantity', 'Rate')
  bittrex_dgd_average_100_bid = calculate_average_price(response[:bittrex_dgd_order_book], 100, 'buy', 'Quantity', 'Rate')

  bittrex_eth_average_100_ask = calculate_average_price(response[:bittrex_eth_order_book], 100, 'sell', 'Quantity', 'Rate')
  bittrex_eth_average_100_bid = calculate_average_price(response[:bittrex_eth_order_book], 100, 'buy', 'Quantity', 'Rate')

  yunbi_dgd_eth_average_100_buy = (yunbi_dgd_average_100_ask.to_f / yunbi_eth_average_100_bid.to_f).round(6)
  yunbi_dgd_eth_average_100_sell = (yunbi_dgd_average_100_bid.to_f / yunbi_eth_average_100_ask.to_f).round(6)

  bittrex_dgd_eth_average_100_buy = (bittrex_dgd_average_100_ask.to_f / bittrex_eth_average_100_bid.to_f).round(6)
  bittrex_dgd_eth_average_100_sell = (bittrex_dgd_average_100_bid.to_f / bittrex_eth_average_100_ask.to_f).round(6)

  "yunbi 100个DGD的平均买价: #{yunbi_dgd_eth_average_100_buy}, yunbi 100个DGD的平均卖价: #{yunbi_dgd_eth_average_100_sell}" + "\n" +
    "bittrex 100个DGD的平均买价: #{bittrex_dgd_eth_average_100_buy}, bittrex 100个DGD的平均卖价: #{bittrex_dgd_eth_average_100_sell}"
end
