import React, { Component } 		from 'react';
import { connect } 							from 'react-redux';
import { Link } 								from 'react-router';
import { getUsers, deleteUser } from '../store/users/actions';
import Paginator								from '../containers/paginator';

class Users extends Component {

	componentWillMount() {
		this.props.getUsers();
	}

	onDeleteClick(event) {
		if (!confirm('Are you sure?')) { return };

		const id = event.target.dataset.id;
		this.props.deleteUser(id);
	}

	onChangePage(page) {
		this.props.getUsers({page: page});
	}

	renderRows() {
		return this.props.users.map(user => {
			return(
				<tr key={user.id}>
					<td>{`${user.first_name} ${user.last_name}`}</td>
					<td>{user.email}</td>
					<td>{user.roles.map(r => r.name).join(",")}</td>
					<td>
						<div className="pull-right">
							<Link to={`/admin/users/${user.id}/edit`} className="btn btn-primary action">Edit</Link>
							<button data-id={user.id} onClick={this.onDeleteClick.bind(this)} className="btn btn-danger">Delete</button>
						</div>
					</td>
				</tr>
			);
		})
	}

	render() {
		return(
			<div>
				<h1>Users</h1>

				<table className="table table-striped">
					<thead>
						<tr>
							<th>Name</th>
							<th>Email</th>
							<th>Roles</th>
							<th></th>
						</tr>
					</thead>
					<tbody>
						{this.renderRows()}
					</tbody>
				</table>

				<Paginator 
					page 					= {this.props.page}
					totalPages 		= {this.props.totalPages}
					onChangePage 	= {this.onChangePage.bind(this)} />
			</div>
		);
	}

}

function mapStateToProps(state) {
	return {
		users: 			state.users.collection,
		user:  			state.users.instance,
		errors: 		state.users.errors,
		busy: 			state.users.fetching,
		page: 			state.users.page,
		totalPages: state.users.totalPages
	};
}

export default connect(mapStateToProps, {getUsers, deleteUser})(Users);