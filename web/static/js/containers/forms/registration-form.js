import React, { Component, PropTypes } 	from 'react';
import Form															from '../form';
import { Field }												from 'redux-form';
import { cleanField } 									from '../../app/utils';
import { connect }											from 'react-redux';
import { signUp } 											from '../../store/auth/actions';

class RegistrationForm extends Component {

	static contextTypes = {
		router: PropTypes.object
	}

	onSubmitForm(data) {
		this.props.signUp(data, this.context.router);
	}

	render() {
		const { apiErrors, fetching, submitTitle } = this.props;

		return(
			<div className="col-md-6">
				<Form 
					onSubmit 			= { this.onSubmitForm.bind(this) }
					apiErrors 		= { apiErrors }
					submitTitle 	= { submitTitle }
					fetching 			= { fetching } >

					<Field label="Email" name="email" type="email" component="input" required="true" />
					<Field label="First Name" name="first_name" type="text" component="input" required="true" />
					<Field label="Last Name" name="last_name" type="text" component="input" required="true" />
					<hr/>
					<Field label="Password" name="password" type="password" component="input" required="true" />

				</Form>
			</div>
		);
	}
}

export default connect(null, {signUp})(RegistrationForm);