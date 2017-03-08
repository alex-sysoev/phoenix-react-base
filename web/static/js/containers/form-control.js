import React, { Component } from 'react';
import { cleanField } 			from '../app/utils';
import SelectControl				from './select-control';

class FormControl extends Component {

	renderLabel({name, label}) {
		if (label) {
			return <label>{label}</label>;
		}

		return "";
	}

	renderError(field) {
		const { touched, error, apiError } = field;

		if (touched && error) {
			return <div className="text-help text-danger">{error}</div>;
		} 

		if (!error && apiError && apiError.length > 0) {
			return <div className="text-help text-danger">{apiError}</div>;
		}

		return "";
	}

	render() {
		const { touched, error, controlType, apiError, valid } = this.props;
		
		let klass = ((touched && error) || apiError) ? 'has-error' : '';

		if (touched && valid) {
			klass = 'has-success';
		}
		
		const propsToPass = { ...this.props, className: `form-control ${this.props.className || ''}` };

		let controlProps 	= {
			...cleanField(propsToPass)
		}

		return (
			<div className={`form-group ${klass}`}>
				{ this.renderLabel(this.props) }
				{ React.createElement(controlType, controlProps) }
				{ this.renderError(this.props) }
			</div>
		);
	}

}

export default FormControl;