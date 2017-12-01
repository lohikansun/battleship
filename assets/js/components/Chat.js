import React from 'react'

export default class Chat extends React.Component {
  constructor(props) {
    super(props)
    this.state = this.props.state
    this.props.channel.on("state", this.receive.bind(this))
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
  }

  render() {
    let players = [];
    for (var i = 0; i < this.state.players.length; i++)
    {
      var k = "p" + i;
      if (this.props.user != this.state.players[i])
      {
        players.push(<li className="list-group-item" key={k}>{this.state.players[i]}{this.state.gameActive ? null : <span className="challenge"><button className="btn btn-danger" onClick={this.challenge.bind(this, this.state.players[i])}>Challenge!</button></span>}</li>);
      }
    }

    let messages = [];
    var i = 0;
    this.state.messages.forEach(function(message) {
      k = 'm' + i;
      i++;
      messages.push(<p key={k}><b>{message.player}</b>: {message.text}</p>);
    });
    return (
      <div className="card-block">
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
