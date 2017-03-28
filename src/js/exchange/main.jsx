import React, {Component} from 'react';
import {connect} from 'react-most';
import Intent from '../intent';
import {identity} from 'lodash/fp';
import {periodic, just, fromPromise} from 'most';
import Exchange from './exchange'
import rest from '../rest'

const API_ENDPOINT = "http://localhost:5000/exchange/refresh";

const CHECK_HANDSHAKE_INTERVAL = 60000;
const HANDSHAKE_TIMEOUT = 120000;

const Main = props => {
  return (
    <div>
      <p>{props.data}</p>
      <Exchange></Exchange>
    </div>
  );
};

function getTime() {
  return `[${new Date().toLocaleTimeString()}]`;
}

Main.defaultProps = {
  data: [],
  disconnected: true,
  lastHandshakeDate: 0
};

export default connect(intent$ => {
  let sink$ = intent$
    .merge(periodic(CHECK_HANDSHAKE_INTERVAL, Intent.CheckHandshake()))
    .flatMap(Intent.case({
      CheckHandshake: () => {
        return just(state => {
          let delta = Date.now() - state.lastHandshakeDate;
          console.log(getTime(), `Handshake time range: ${delta / 1000} seconds`)
          if(delta > HANDSHAKE_TIMEOUT) {
            console.log(getTime(), `Reconnect`);
            rest(API_ENDPOINT).then(function (data) {
              // alert(data[0].name);
              console.log("+++++++++++++++++++++")
              debugger
              console.log(data)
              intent$.send(Intent.ReceiveData(data));
            })
            return { disconnected: false };
          }
          return state;
        });
      },
      _: ()=>just(identity)}))
  return {
    sink$
  };
})(Main);

