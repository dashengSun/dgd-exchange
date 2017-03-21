#! /bin/bash

bittrex_dgd=$(curl https://bittrex.com/api/v1.1/public/getticker\?market\=BTC-DGD)
# bittrex_eth=$(curl https://bittrex.com/api/v1.1/public/getticker\?market\=BTC-ETH)

yunbi_dgd=$(curl https://yunbi.com/api/v2/tickers/dgdcny.json)
# yunbi_eth=$(curl https://yunbi.com/api/v2/tickers/ethcny.json)
yunbi_btc=$(curl https://yunbi.com/api/v2/tickers/btccny.json)

echo "-----------------------------------"
echo "服务器返回结果如下:"
echo "The bittrex_dgd response: $bittrex_dgd"
# echo "The bittrex_eth response: $bittrex_eth"
echo "The yunbi_dgd response: $yunbi_dgd"
# echo "The yunbi_eth response: $yunbi_eth"
echo "-----------------------------------"


bittrex_dgd_bid=$(echo $bittrex_dgd | jq '.result.Bid')
bittrex_dgd_ask=$(echo $bittrex_dgd | jq '.result.Ask')

# bittrex_eth_bid=$(echo $bittrex_eth | jq '.result.Bid')
# bittrex_eth_ask=$(echo $bittrex_eth | jq '.result.Ask')


yunbi_dgd_bid=$(echo $yunbi_dgd | jq '.ticker.buy' | bc -l)
yunbi_dgd_ask=$(echo $yunbi_dgd | jq '.ticker.sell' | bc -l)

# yunbi_eth_bid=$(echo $yunbi_eth | jq '.ticker.buy' | bc -l)
# yunbi_eth_ask=$(echo $yunbi_eth | jq '.ticker.sell' | bc -l)
yunbi_btc_bid=$(echo $yunbi_btc | jq '.ticker.buy' | bc -l)
yunbi_btc_ask=$(echo $yunbi_btc | jq '.ticker.sell' | bc -l)

# bittrex_dgd_eth_buy=$(echo "$bittrex_dgd_ask / $bittrex_eth_bid" | bc -l)
# bittrex_dgd_eth_sell=$(echo "$bittrex_dgd_bid / $bittrex_eth_ask" | bc -l)
# bittrex_dgd_btc_buy=$(echo "$bittrex_dgd_ask / $bittrex_btc_bid" | bc -l)
# bittrex_dgd_btc_sell=$(echo "$bittrex_dgd_bid / $bittrex_btc_ask" | bc -l)
bittrex_dgd_btc_buy=$(echo "$bittrex_dgd_ask" | bc -l)
bittrex_dgd_btc_sell=$(echo "$bittrex_dgd_bid" | bc -l)

# yunbi_dgd_eth_buy=$(echo "$yunbi_dgd_ask / $yunbi_eth_bid" | bc -l)
# yunbi_dgd_eth_sell=$(echo "$yunbi_dgd_bid / $yunbi_eth_ask" | bc -l)
yunbi_dgd_btc_buy=$(echo "$yunbi_dgd_ask / $yunbi_btc_bid" | bc -l)
yunbi_dgd_btc_sell=$(echo "$yunbi_dgd_bid / $yunbi_btc_ask" | bc -l)

echo "-----------------------------------"
echo "以下均以BTC计价"
echo "-----------------------------------"

echo "***********************************"
echo "yunbi买价: $yunbi_dgd_btc_buy, yunbi卖价: $yunbi_dgd_btc_sell"
echo "***********************************"

echo "***********************************"
echo "bittrex买价: $bittrex_dgd_btc_buy, bittrex卖价: $bittrex_dgd_btc_sell"
echo "***********************************"
