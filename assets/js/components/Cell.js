import React from "react";

export default class Cell extends React.Component {
  render() {
    var cID = this.props.id + (10 * this.props.rowID);
    var cKey = 'c' + cID.toString();
    return (
      <td id={cID} key={cKey}>test</td>
    );
  }
};
