import React, { Component } 	from 'react';
import { connect } 						from 'react-redux';
import Form 									from '../containers/form';
import { Field }							from 'redux-form';
import Message 								from '../containers/message';
import ReactDOM 							from 'react-dom';

import { 
	joinConversation, 
	leaveConversation,
	sendMessage
}		from '../store/conversations/actions';	

class Conversation extends Component {

	constructor(props) {
		super(props);

		this.state = {
			message: "",
			scrolled: false
		}
		
		this.onSendMessage 		= this.onSendMessage.bind(this);
		this.onMessageChange 	= this.onMessageChange.bind(this);
	}

	componentDidMount() {
		this.props.joinConversation(this.props.socket, 1);
	}

	componentWillReceiveProps(nextProps) {
		if (!this.props.socket && nextProps.socket) {
			nextProps.joinConversation(nextProps.socket, 1);
		}
	}

	componentDidUpdate(prevProps, prevState) {
		if (this.canScrollBottom() || !this.state.scrolled) {
			this.scrollToBottom();
		}
	}

	componentWillUnmount() {
		this.props.leaveConversation(this.props.channel);
	}

	scrollToBottom() {
		const node = ReactDOM.findDOMNode(this.chatBottom);

		if (node) {
			node.scrollIntoView({behavior: "smooth"});

			if (!this.state.scrolled) {
				this.setState({scrolled: true})
			}
		}
	}

	onSendMessage(event) {
		event.preventDefault();
		let message = this.state.message;

		if (message.trim() == "") { 
			return 
		}
		
		this.props.sendMessage(this.props.channel, {content: message});

		this.setState({ message: "" });
	}

	onMessageChange(event) {
		this.setState({ message: event.target.value })
	}

	canScrollBottom() {
		const node = ReactDOM.findDOMNode(this.chatBox);
		return node ? (node.scrollTop + 1000 >= node.scrollHeight) : false;
	}

	render() {

		if (this.props.fetching || !this.props.conversation) { return null; }

		const { conversation: { name }, messages } = this.props;

		return(
			<div className="col-md-12">

				<div className="panel panel-success conversation-panel">
					<div className="panel-heading">
						<h2>Conversation [{name}]</h2>
					</div>
					
					<div className="conv-body panel-body" ref={(el) => {this.chatBox = el}}>
						{messages.map((m) => {
							return <Message message={m} key={m.id} />
						})}
						<div ref={(el) => { this.chatBottom = el; }}></div>
					</div>
					
					<div className="panel-footer">
						<form onSubmit={this.onSendMessage} className="input-group">
							<input
								placeholder	=	"Type your message"
								className		= "form-control"
								value				= { this.state.message }
								onChange 		= { this.onMessageChange }
							/>
							<span className="input-group-btn">
								<button type="submit" className="btn btn-primary">Send</button>
							</span>
						</form>
					</div>
				</div>
			</div>
		);
	}

}

function mapStateToProps(state) {
	return {
		conversation: state.conversations.instance,
		messages: 		state.conversations.messages,
		fetching: 		state.conversations.fetching,
		socket: 			state.auth.socket,
		channel: 			state.conversations.channel
	}
}

export default connect(
	mapStateToProps, 
	{joinConversation, leaveConversation, sendMessage}
)(Conversation);