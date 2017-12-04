import ReactDOM from 'react-dom';
import React from 'react'
import Table from './Table'

export default class Game extends React.Component {
  constructor(props) {
    super(props)
    this.state = this.props.state
    this.props.channel.on("start", this.start.bind(this))
    this.props.channel.on("state", this.set_state.bind(this))
  }

  start(state) {
    state.started = true;
    this.setState(state);
  }

  set_state(state) {
    this.setState(state);
  }

  accept() {
    this.props.channel.push('accept', {})
      .receive("ok", state => {
        this.set_state(state);
      })
  }

  reject() {
    this.props.tableChannel.push("endGame", {})
      .receive("ok", state => {this.props.endGame(state)})

  }

  clickYours(cellKey){

    if (!this.state.started)
    {
      this.props.channel.push("click", {key: cellKey})
        .receive("ok", state => {this.set_state(state)})
    }

  }

  clickTheirs(cellKey){

    if (this.state.started)
    {
      this.props.channel.push("click", {key: cellKey})
        .receive("ok", state => {this.set_state(state)})
    }
  }

  rotate() {
    this.props.channel.push("rotate", {})
      .receive("ok", state => {this.setState(state)})
  }

  render() {
    var page = null;
    var directions = null;
    if (this.state.ships_to_place.length > 0) {
    var directions = this.state.horizontal ? <p>Placing ship of length {this.state.ships_to_place[0]} horizontally. Click leftmost cell of ship on your grid to place.</p>
  : <p>Placing ship of length {this.state.ships_to_place[0]} vertically. Click uppermost cell of ship on your grid to place.</p>
  }
  else {
    directions = <p>Waiting for other player to place ships</p>
  }

var placement = this.state.started ? <h3 className="text-center">Turn: {this.state.turn}</h3> :
    <div>
      <form>
        <div className="radio">
          <label>
            <input type="radio"
              checked={this.state.horizontal} onChange={this.rotate.bind(this)} />
            Horizontal
          </label>
        </div>
        <div className="radio">
          <label>
            <input type="radio"
              checked={!this.state.horizontal} onChange={this.rotate.bind(this)} />
            Vertical
          </label>
        </div>
      </form>
      {directions}
      </div>

    if (this.state.accepted){
      page =
        <div className="container">
          <div>{placement}</div>
          <div className="row">
        <div className="col-xs-6">
            <Table  name={window.user_name} sunk={this.state.your_sunk}  ships={this.state.ships} hits={this.state.their_hits} misses={this.state.their_misses} click={this.clickYours.bind(this)}/>
        </div>
        <div className="col-xs-6">
          <Table  name={this.state.opponent} sunk={this.state.their_sunk} hits={this.state.your_hits} misses={this.state.your_misses} click={this.clickTheirs.bind(this)}/>
        </div>
    </div>
</div>
    }
    else {
      page = this.props.challenger == window.user_name ? <h3>Waiting for {this.props.challenged} to respond to challenge...</h3> :
        <div className="btn-group">
        <h3>You have been challenged by {this.props.challenger}</h3>
          <button onClick={this.accept.bind(this)}  className="btn btn-success">Accept</button>
          <button onClick={this.reject.bind(this)} className="btn btn-danger">Reject</button>
        </div>
    }


    return (
      <div>{page}</div>

    );
  }
}
