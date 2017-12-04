import React from 'react'
import socket from "../socket"
import ReactDOM from 'react-dom';
import Game from './Game'

export default class Chat extends React.Component {
  constructor(props) {
    super(props)
    this.state = this.props.state
    this.props.channel.on("state", this.receive.bind(this))
    this.props.channel.on("challenge", this.challengeReceived.bind(this))
    this.props.channel.on("end", this.endGame.bind(this))
  }


  endGame(state) {
      let root = document.getElementById('game');
      ReactDOM.unmountComponentAtNode(root);
      this.receive(state)
  }

  challengeReceived(state) {
    this.setState(state)
    if (this.props.user == state.challenged)
    {
      this.start_game();
    }
  }

  start_game() {
    let channel = socket.channel("player:" + window.user_name, window.table_name);
    channel.join()
      .receive("ok", state => {
        let root = document.getElementById('game');
        ReactDOM.render(<Game state={state} endGame={this.endGame.bind(this)} tableChannel={this.props.channel} challenged={this.state.challenged} challenger={this.state.challenger} channel={channel} />, root);
      })
      .receive("error", resp => {console.log("Unable to join", resp);});
  }

  receive(state) {
    this.setState(state);
  }

  post() {
    var input = document.getElementById('message-input');
    this.props.channel.push("message", {message: input.value})
      .receive("ok", state => {this.receive(state)})
  }

  challenge(player) {
    this.props.channel.push("challenge", {player: player})
      .receive("ok", state => {this.receive(state)})

      this.start_game();
  }

  kill() {
    this.props.channel.push("endGame", {})
      .receive("ok", state => {this.endGame(state)})
  }

  render() {
    let players = [];
    for (var i = 0; i < this.state.players.length; i++)
    {
      var k = "p" + i;
      if (this.props.user != this.state.players[i])
      {
        players.push(<li className="list-group-item" key={k}>{this.state.players[i]}{this.state.ctive ? null : <span className="challenge"><button className="btn btn-danger" onClick={this.challenge.bind(this, this.state.players[i])}>Challenge!</button></span>}</li>);
      }
    }

    var kill = this.state.gameActive ? <button className="btn btn-danger" onClick={this.kill.bind(this)}>Kill Game</button> : null
    var lastWinner = this.state.lastWinner != "" ? <h3>Last Winner: {this.state.lastWinner}</h3> : null
    let messages = [];
    var i = 0;
    this.state.messages.forEach(function(message) {
      k = 'm' + i;
      i++;
      messages.push(<p key={k}><b>{message.player}</b>: {message.text}</p>);
    });
    return (
      <div className="card-block">
        {lastWinner}
        {kill}
        <h5>Other Players:</h5>
        <div><ul className="list-group">{players}</ul></div>

        <div>
          <div className="input-group">
          <input id="message-input" type="text" className="form-control"></input>
          <span className="input-group-btn">
            <button onClick={this.post.bind(this)} className="btn btn-secondary" type="button">Post</button>
          </span>
        </div>
        <h3>Messages:</h3>
        {messages}
        </div>
      </div>
    );
  }
}
