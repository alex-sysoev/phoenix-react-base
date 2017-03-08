import React, { Component, PropTypes } 	from 'react';
import Form															from '../form';
import SelectControl										from '../select-control';
import { Field }												from 'redux-form';
import { cleanField } 									from '../../app/utils';
import { connect }											from 'react-redux';
import { updateUser } 									from '../../store/users/actions';

class UserForm extends Component {

	static contextTypes = {
		router: PropTypes.object
	}

	onSubmitForm(data) {
		const _data = { ...data, role_ids: data.role_ids.map(id => parseInt(id)) }
		this.props.updateUser(this.props.userId, _data, this.context.router, this.props.redirect);
	}

	render() {
		const { apiErrors, fetching, initialValues, submitTitle, userId, isAdmin } = this.props;

		if (fetching || !initialValues || initialValues.id != userId) {
			return null;
		}

		const roleField = isAdmin ? (<Field 
													label="Roles" 
													name="role_ids"
													component={SelectControl}
													itemsUrl="/roles"
													multiple={true} 
													required="true" />) : (<div></div>);
		return(
			<div className="col-md-6">
				<Form 
					onSubmit 			= { this.onSubmitForm.bind(this) }
					apiErrors 		= { apiErrors }
					submitTitle 	= { submitTitle }
					fetching 			= { fetching }
					initialValues = { {...initialValues, role_ids: initialValues.roles.map(r => r.id)} }>

					<Field label="Email" name="email" type="email" component="input" required="true" />
					<Field label="First Name" name="first_name" type="text" component="input" required="true" />
					<Field label="Last Name" name="last_name" type="text" component="input" required="true" />
					
					{ roleField }
					
					<hr/>
					
					<Field 
						label="Password" 
						name="password" 
						type="password" 
						component="input"
						min={8} />
					<Field 
						label="Password Confirmation" 
						name="password_confirmation"
						type="password"
						component="input" />
				</Form>
			</div>
		);
	}
}

export default connect(null, {updateUser})(UserForm);