import React, { Component } 	from 'react';
import { Link }								from 'react-router';
import { connect }						from 'react-redux';
import UserForm 							from '../containers/forms/user-form';
import { getUser }						from '../store/users/actions';

class UserEdit extends Component {

	componentWillMount() {
		this.props.getUser(this.props.params.id);
	}

	render() {

		const { user, params, apiErrors, isAdmin } = this.props;

		return(
			<div>
				<h1>Edit User</h1>
				<Link to="/admin/users" className="btn btn-custom">Go Back</Link>
				<div>
					<UserForm 
						submitTitle		= "Update"
						userId 				= { params.id }
						initialValues = { user }
						redirect 			= "/admin/users"
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
		user: 			state.users.instance,
		apiErrors: 	state.users.errors,
		isAdmin:  	state.auth.isAdmin
	}
}

export default connect(mapStateToProps, {getUser})(UserEdit);