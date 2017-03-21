require 'httparty'
require 'data.either'
require 'json'

class YunbiApi
  include HTTParty
  base_uri ENV['YUNBI_API_ENDPOINT']

  def fetch_market_exchange market
    response = self.class.get("/tickers/#{market}.json", {
        :headers => {'Content-Type' => 'application/json', 'Accept' => 'application/json'}
    })
    response
  end

end

class YunbiApiError < StandardError ; end
