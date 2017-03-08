import React, { Component } 	from 'react';
import { connect }						from 'react-redux';
import RegistrationForm 			from '../containers/forms/registration-form';

class Registration extends Component {

	render() {

		const { apiErrors, fetching } = this.props;

		return(
			<div>
				<h1>Sign Up</h1>

				<div>
					<RegistrationForm 
						submitTitle		= "Sign Up"
						apiErrors			= { apiErrors }
						fetching			= { fetching }
					/>
				</div>
			</div>
		);
	}

}

function mapStateToProps(state) {
	return {  
		apiErrors: state.auth.errors,
		fetching:  state.auth.fetching
	}
}

export default connect(mapStateToProps)(Registration);