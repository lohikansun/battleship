import ReactDOM from 'react-dom';
import React from 'react'
import Table from './Table'

export default class Game extends React.Component {
  constructor(props) {
    super(props)
    this.state = this.props.state
    this.props.channel.on("start", this.start.bind(this))
  }

  start(state) {
    state.started = true;
    this.setState(state);
  }

  accept() {
    this.props.channel.push('accept', {})
      .receive("ok", state => {
        this.start(state);
      })
  }

  reject() {
    this.props.tableChannel.push("endGame", {})
      .receive("ok", state => {this.props.endGame(state)})

  }

  clickCell(x, y){
    console.log(x,y);
  }

  render() {
    var page = null;
    if (this.state.accepted){
      page =
        <div className="container">
          <div className="row">
        <div className="col-xs-6">
            <Table id={"Your"} ships={this.state.ships} click={this.clickCell.bind(this)}/>
        </div>
        <div className="col-xs-6">
          <Table id={"Their"} hits={this.state.hits} misses={this.state.misses} click={this.clickCell.bind(this)}/>
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
