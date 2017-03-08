import React, { Component } 	from 'react';
import { Link }								from 'react-router';

class Dashboard extends Component {

	render() {

		return(
			<div className="col-md-12">
				<div className="panel panel-default">
					<div className="panel panel-body">
						<ul>
							<li>
								<Link to="/admin/users">Users</Link>
							</li>
							<li>
								<Link to="/conversation">General Channel</Link>
							</li>
						</ul>
					</div>
				</div>
			</div>
		);
	}

}

export default Dashboard;