import React, { Component } from 'react';
import { connect } 					from 'react-redux';
import { resetFlash }				from '../store/flash/actions';

class FlashMessage extends Component {

	onCloseClick() {
		this.props.resetFlash();
	}

	render() {

		const { message, type } = this.props;

		if (!type) {
			return <div></div>;
		}

		return(
			<div className="col-md-12">
				<div className={`alert alert-${type}`}>
					{ message }

					<button onClick={this.onCloseClick.bind(this)} className="close">
						<span>&times;</span>
					</button>
				</div>
			</div>
		);
	}

}

function mapStateToProps( state ) {
	return {
		message: 	state.flash.message,
		type: 		state.flash.type
	}
}

export default connect(mapStateToProps, { resetFlash })(FlashMessage);