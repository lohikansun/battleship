import React from "react"

//import Row from "./Row"

export default class Table extends React.Component {
  constructor(props) {
    super(props)
    this.state = this.props.state
  }

  myFunction(key) {
    console.log(key);
  }
  render() {
    let rows = [];
    for (var i = 0; i < 10; i++){
      let rowID = `row${i}`
      let cell = []
      for (var j = 0; j < 10; j++){
        let cellID = `cell${i}-${j}`
        cell.push(<td className="cell" onClick={() => this.cellClick(cellID)} key={cellID} id={cellID}></td>)
      }
      rows.push(<tr key={i} id={rowID}>{cell}</tr>)
    }
    return (
      <table className="table table-bordered">
    <tbody>{rows}</tbody>
    </table>
  );
  }
}
