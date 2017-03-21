require 'httparty'
require 'data.either'
require 'json'

class BittrexApi
  include HTTParty
  base_uri ENV['BITTREX_API_ENDPOINT']

  def fetch_market_exchange market
    response = self.class.get("/public/getticker", {
      :headers => {'Content-Type' => 'application/json', 'Accept' => 'application/json'},
      :query => {'market' => market}

    })
    response
  end

end

class BittrexApiError < StandardError ; end
