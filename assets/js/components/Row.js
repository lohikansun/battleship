import React from "react"
import Cell from "./Cell"


export default class Row extends React.Component {



  render() {
    let cells = [];
    for (var i = 0; i < 10; i ++) {
      cells.push(<Cell id={i} rowID={this.props.id} />);
    }
    var rKey = 'r' + this.props.id.toString();
    return (
    <tr key={rKey} id={this.props.id}>{cells}</tr>
  );
  }
}
