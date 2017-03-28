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
      <p>yunbi买价: {props.yunbi_dgd_eth_buy}</p>
      <p>yunbi卖价: {props.yunbi_dgd_eth_sell}</p>
      <p>bittrex买价: {props.bittrex_dgd_eth_buy}</p>
      <p>bittrex卖价: {props.bittrex_dgd_eth_sell}</p>

      <h1>前100的交易:</h1>
      <p>yunbi 100个DGD的平均买价: {props.yunbi_dgd_eth_average_100_buy}</p>
      <p>yunbi 100个DGD的平均卖价: {props.yunbi_dgd_eth_average_100_sell}</p>
      <p>bittrex 100个DGD的平均买价: {props.bittrex_dgd_eth_average_100_buy}</p>
      <p>bittrex 100个DGD的平均卖价: {props.bittrex_dgd_eth_average_100_sell}</p>
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
