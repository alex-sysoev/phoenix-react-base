import React, { Component } from "react";

class Paginator extends Component {

	constructor(props) {
		super(props);
		
		this.state = {
			page: this.props.page
		}

	}

	componentWillReceiveProps(nextProps) {
		this.setState({page: this.props.page})
	}

	onPageClick(event) {
		const selected = event.target.dataset.page
		this.props.onChangePage(selected);
	}

	renderPage(pageNumber) {

		const { page, totalPages } = this.props; 
		const klass = page == pageNumber ? "active" : "";

		return(
			<li className={klass} key={pageNumber} style={{cursor: "pointer"}}>
				<a onClick={this.onPageClick.bind(this)} data-page={pageNumber}>{ pageNumber }</a>
			</li>
		);
	}

	render() {
		const total = parseInt(this.props.totalPages || "0");
		let 	pages = [...Array(total+1).keys()].filter(p => { return p > 0 });

		if (pages.length <= 1) {
			return <div></div>;
		}

		return(
			<div className="pull-right">
				<ul className="pagination">
					{ pages.map(p => { return this.renderPage(p); }) }
				</ul>
			</div>
		);
	}

}

export default Paginator;