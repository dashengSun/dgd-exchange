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
  response = call_market_api
  order_book_response = call_order_book_api

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
  puts yunbi_dgd_order_book,yunbi_eth_order_book
  puts '===========++++++++++++++==========='
  puts bittrex_dgd_order_book, bittrex_eth_order_book
end
