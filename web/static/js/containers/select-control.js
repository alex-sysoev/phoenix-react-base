import React, { Component } from 'react';
import Select2 							from 'react-select2-wrapper';
import api 									from '../app/api';

import 'react-select2-wrapper/css/select2.css';

class SelectControl extends Component {

	constructor(props) {
		super(props);

		this.state = {
			items: []
		}
	}

	componentWillMount() {
		if (this.props.itemsUrl) {
			this.getItems();
		}
	}

	getItems() {
		api.get(this.props.itemsUrl)
			.then((response) => {
					this.setState({
						items: response.data.map(i => {
							return { id: i.id, text: i.name };
						})
					})
			})
			.catch((error) => {
				this.setState({items: []})
			})
	}

	render() {
		const { itemsUrl, ...rest } = this.props;

		return(
			<Select2
				{ ...rest }
				onClose	 = { this.props.onBlur }
				data 		 = { this.state.items } />
		);
	}

}

export default SelectControl;