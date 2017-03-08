import React, { Component } 	from 'react';
import { connect }						from 'react-redux';
import { Link }								from 'react-router';
import UserForm 							from '../containers/forms/user-form';

class Profile extends Component {

	render() {
		const { user, apiErrors, isAdmin } = this.props;

		if (!user) {
			return(
				<div></div>
			);
		}

		return(
			<div>
				<h1>Profile</h1>
				<div>
					<UserForm 
						submitTitle		= "Update Profile"
						userId 				= { user.id }
						initialValues = { user }
						apiErrors			= { apiErrors }
						isAdmin				= { isAdmin }
					/>
				</div>
			</div>
		);
	}

}

function mapStateToProps(state) {
	return {
		user: 			state.auth.currentUser,
		apiErrors: 	state.auth.errors,
		isAdmin: 		state.auth.isAdmin
	}
}

export default connect(mapStateToProps)(Profile);