import React, { Component } from "react";

class Message extends Component {

	render() {
		const { message } = this.props;
		const date = new Date(message.inserted_at);

		return(
			<div className="panel panel-default">
				<div className="panel-heading">
					<p>
						<span>
							<strong>{ `${message.user.first_name} ${message.user.last_name}` }</strong>
						</span>
						<span> ({ date.toLocaleString() })</span>
					</p>
				</div>
				<div className="panel-body">
					<p>{ message.content }</p>
				</div>
			</div>
		);
	}

}

export default Message;