import React from "react"

//import Row from "./Row"

export default class Table extends React.Component {
  constructor(props) {
    super(props)
    //this.state = this.props.state
  }

  myFunction(d) {
    this.props.click();
  }
  render() {
    let rows = [];
    for (var i = 0; i < 10; i++){
      let rowID = this.props.id + `row${i}`
      let cell = []
      for (var j = 0; j < 10; j++){
        let cellKey = this.props.id + `cell${i}-${j}`
        let x = i;
        let y = j;
        cell.push(<td className="cell water" onClick={() => this.props.click(x, y)} key={cellKey} id={cellKey}></td>)
      }
      rows.push(<tr key={i} id={rowID}>{cell}</tr>)
    }
    return (
      <div>
        <h2 className="text-center">{this.props.id + " Grid"}</h2>
      <table className="table table-bordered">
    <tbody>{rows}</tbody>
    </table>
    </div>
  );
  }
}
