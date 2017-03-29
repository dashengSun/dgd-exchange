import React from 'react';
import {connect} from 'react-most';
import Intent from '../intent';
import {identity} from 'lodash/fp';
import {periodic, just, fromPromise} from 'most';


const Exchange = props => {
  return (
    <div>
      <h1>{props.lastHandshakeDate}</h1>

      <h1>置顶的交易:</h1>
      <p>yunbi买价: {props.yunbi_dgd_eth_buy}, yunbi卖价: {props.yunbi_dgd_eth_sell}</p>
      <p>bittrex买价: {props.bittrex_dgd_eth_buy}, bittrex卖价: {props.bittrex_dgd_eth_sell}</p>

      <h1>前100的交易:</h1>
      <p>yunbi 100个DGD的平均买价: {props.yunbi_dgd_eth_average_100_buy}, yunbi 100个DGD的平均卖价: {props.yunbi_dgd_eth_average_100_sell}</p>
      <p>bittrex 100个DGD的平均买价: {props.bittrex_dgd_eth_average_100_buy}, bittrex 100个DGD的平均卖价: {props.bittrex_dgd_eth_average_100_sell}</p>
    </div>
  );
};

function getTime() {
  return `[${new Date().toLocaleTimeString()}]`;
}

export default connect(intent$ => {
  let sink$ = intent$.map(Intent.case({
    ReceiveData: data => {
      // const data = JSON.parse(msg);
      console.log("---------------------")
      console.log(data)
      if (typeof data === 'string') {
        console.log(getTime(), `Handshake ${data}`);
        return state => ({lastHandshakeDate: Date.now()});
      } else {
        console.log(getTime(), 'Received data.');
        if (data.market.yunbi_dgd_eth_sell > data.market.bittrex_dgd_eth_buy) {
          let profit = (data.market.yunbi_dgd_eth_sell - data.market.bittrex_dgd_eth_buy) / data.market.yunbi_dgd_eth_sell
          if (profit > 0.005) {
            alert("可交易,卖出云币DGD -> RMB -> ETH => (ETH)B网 -> BTC -> 买入B网DGD" + "\n" +
              `yunbi卖价: ${data.market.yunbi_dgd_eth_sell}, bittrex买价: ${data.market.bittrex_dgd_eth_buy}` + "\n" +
              `盈利率: ${profit * 100}%`)
          }
        }
        if (data.market.bittrex_dgd_eth_sell > data.market.yunbi_dgd_eth_buy) {
          let profit = (data.market.bittrex_dgd_eth_sell - data.market.yunbi_dgd_eth_buy) / data.market.bittrex_dgd_eth_sell
          if (profit > 0.005) {
            alert("可交易,卖出B网DGD ->BTC -> ETH => (ETH)云币 -> RMB -> 买入云币DGD" + "\n" +
              `bittrex卖价: ${data.market.bittrex_dgd_eth_sell}, yunbi买价: ${data.market.yunbi_dgd_eth_buy}` + "\n" +
              `盈利率: ${profit * 100}%`)
          }
        }

        // 100 average
        if (data.order.yunbi_dgd_eth_average_100_sell > data.order.bittrex_dgd_eth_average_100_buy) {
          let profit = (data.order.yunbi_dgd_eth_average_100_sell - data.order.bittrex_dgd_eth_average_100_buy) / data.order.yunbi_dgd_eth_average_100_sell
          if (profit > 0.005) {
            alert("可交易,卖出云币前100个DGD -> RMB -> ETH => (ETH)B网 -> BTC -> 买入B网前100个DGD" + "\n" +
              `yunbi前100平均卖价: ${data.order.yunbi_dgd_eth_average_100_sell}, bittrex前100平均买价: ${data.order.bittrex_dgd_eth_average_100_buy}` + "\n" +
              `盈利率: ${profit * 100}%`)
          }
        }
        if (data.order.bittrex_dgd_eth_average_100_sell > data.order.yunbi_dgd_eth_average_100_buy) {
          let profit = (data.order.bittrex_dgd_eth_average_100_sell - data.order.yunbi_dgd_eth_average_100_buy) / data.order.bittrex_dgd_eth_average_100_sell
          if (profit > 0.005) {
            alert("可交易,卖出B网前100个DGD ->BTC -> ETH => (ETH)云币 -> RMB -> 买入云币前100个DGD" + "\n" +
              `bittrex前100平均卖价: ${data.order.bittrex_dgd_eth_average_100_sell}, yunbi前100平均买价: ${data.order.yunbi_dgd_eth_average_100_buy}` + "\n" +
              `盈利率: ${profit * 100}%`)
          }
        }

        return state => ({
          yunbi_dgd_eth_buy: data.market.yunbi_dgd_eth_buy,
          yunbi_dgd_eth_sell: data.market.yunbi_dgd_eth_sell,
          bittrex_dgd_eth_buy: data.market.bittrex_dgd_eth_buy,
          bittrex_dgd_eth_sell: data.market.bittrex_dgd_eth_sell,

          yunbi_dgd_eth_average_100_buy: data.order.yunbi_dgd_eth_average_100_buy,
          yunbi_dgd_eth_average_100_sell: data.order.yunbi_dgd_eth_average_100_sell,
          bittrex_dgd_eth_average_100_buy: data.order.bittrex_dgd_eth_average_100_buy,
          bittrex_dgd_eth_average_100_sell: data.order.bittrex_dgd_eth_average_100_sell,

          lastHandshakeDate: getTime()
        });
      }
    },
    _: ()=>identity
  }));
  return {
    sink$
  }
})(Exchange);
