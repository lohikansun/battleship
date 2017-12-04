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
      let rowID = this.props.name + `row${i}`
      let cell = []
      for (var j = 0; j < 10; j++){


        let cellKey = this.props.name + `cell${i}-${j}`
        var cellType = "water"
        if (this.props.ships != undefined) {
          this.props.ships.forEach(function(element) {
            element.forEach(function(key) {
              if (cellKey == key) {
                cellType = "ship";
              }
            });
          });
        }
        this.props.hits.forEach(function(key) {
          if (cellKey == key) {
            cellType = "hit";
          }
        });

        this.props.misses.forEach(function(key) {
          if (cellKey == key) {
            cellType = "miss";
          }
        });

        let x = i;
        let y = j;
        cell.push(<td className={"cell " + cellType} onClick={() => this.props.click(cellKey)}
         key={cellKey} id={cellKey}></td>)
      }
      rows.push(<tr key={i} id={rowID}>{cell}</tr>)
    }
    return (
      <div>
        <h2 className="text-center">{this.props.name + "\'s Grid"}</h2>
      <table className="table table-bordered">
    <tbody>{rows}</tbody>
    </table>
    <h5 className="text-center">Ships sunk: {this.props.sunk}</h5>
    </div>
  );
  }
}
