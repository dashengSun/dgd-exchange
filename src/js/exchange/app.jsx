import "babel-polyfill"
import ReactDOM from 'react-dom'
import React from 'react'
import Main from './main'
import Most from 'react-most'

const App = React.createClass({
  render(){
    return <Main />;
  }
});
ReactDOM.render(<Most><App/></Most>, document.getElementById('dgd-exchange'));
