import React 				from "react";
import Header 			from '../containers/header';
import FlashMessage from '../containers/flash-message';

export default class App extends React.Component {
  render() {
    return( 
      <div className="container-fluid">
        <Header />
        <FlashMessage />
        {this.props.children}
      </div>
    );
  }
};