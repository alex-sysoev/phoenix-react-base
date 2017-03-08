import React, { Component, PropTypes } 	from 'react';
import { connect } 											from 'react-redux';
import { login } 												from '../store/auth/actions';
import Form 														from '../containers/form';
import { Field }												from 'redux-form';

class Login extends Component {

	static contextTypes = {
		router: PropTypes.object
	}

	handleLogin(data) {
		this.props.login(data, this.context.router);
	}

	render() {

		const { apiErrors, fetching } = this.props;

		return(
			<div className="col-md-6">
				<Form 
					submitTitle	= "Sign In"
					apiErrors		=	{ apiErrors }
					fetching 		= { fetching }
					onSubmit		= { this.handleLogin.bind(this) }>

					<Field placeholder="Email" name="email" type="email" component="input" required="true" />
					<Field name="password" type="password" placeholder="Password" component="input" required="true" />
				
				</Form>
			</div>
		);
	}

} 

function mapStateToProps(state) {
	return {
		fetching: state.auth.fetching,
		apiErrors: state.auth.errors
	}
}

export default connect(mapStateToProps, {login})(Login);