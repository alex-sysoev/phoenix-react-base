import React, { Component, PropTypes } 	from 'react';
import { reduxForm, Field } 						from 'redux-form';
import FormControl											from './form-control';
import { resetApiErrors }								from '../store/actions';
import { connect }											from 'react-redux';

class Form extends Component {

	static contextTypes = {
		router: PropTypes.object
	}

	componentWillUnmount() {
		this.props.resetApiErrors();
	}

	onSubmit(data) {
		this.props.onSubmit(data) || void(0)
	}

	getApiErrorMessage(attr) {
		if (!this.props.apiErrors) { return }
		const error = this.props.apiErrors.filter(error => error.field == attr)[0];
		return error ? error.message : "";
	}

	render() {
		const { submitTitle, handleSubmit, pristine, reset, submitting, fetching } = this.props

 		const children = this.props.children.map(ch => {
 			if (ch.props.component) {
	 			return { ...ch, 
	 				props: { 
	 					...ch.props, 
	 					component: 		FormControl,
	 					controlType: 	ch.props.component,
	 					apiError: 		this.getApiErrorMessage(ch.props.name)
	 				} 
	 			}
 			}

 			return ch;
 		})

		return(
			<form onSubmit={handleSubmit(this.onSubmit.bind(this))}>
				{children}
				<button type="submit" className="btn btn-primary" disabled={submitting || pristine}>
					{submitTitle}
				</button>
			</form>
		);
	}

}

function validate(values, props) {
	const errors = {};
	const emailRegex = /\S+@\S+\.\S+/;

	const fields = Object.keys(props.children).map((k) => {
		return props.children[k].props;
	})

	fields.forEach(field => {
		if (field.type == "email" && !emailRegex.test(values[field.name])) {
			errors[field.name] = "Invalid email format";
		}

		if (field.required) {
			const val 				= values[field.name];
			const noValue 		= !val;
			const emptyValue 	= Array.isArray(val) && val.length === 0;
			
			if (noValue || emptyValue) {
				errors[field.name] = "Required";
			}
		}

		if (values[field.name]) {
			if (field.min && field.number && parseInt(values[field.name]) < parseInt(field.min)) {
				errors[field.name] = `Can't be less than ${field.min}`;
			}

			if (field.max && field.number && parseInt(values[field.name]) > parseInt(field.max)) {
				errors[field.name] = `Can't be greater than ${field.max}`;
			}

			if (field.min && !field.number && values[field.name].length < parseInt(field.min)) {
				errors[field.name] = `Too short. Minimum ${field.min} characters`;
			}

			if (field.max && !field.number && values[field.name].length > parseInt(field.max)) {
				errors[field.name] = `Too long. Maximum ${field.max} characters`;
			}
		}

		if (field.name == "password_confirmation" && values[field.name] != values['password']) {
			errors[field.name] = "Doesn't match password";
		}
	})

	return errors;
}

Form = reduxForm({form: 'someForm', validate})(Form)

export default connect(null, {resetApiErrors})(Form);