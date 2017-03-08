import api 	from '../../app/api';

export const GET_CONV_SUCCESS 	= "GET_CONV_SUCCESS";
export const START_CONV_REQUEST = "START_CONV_REQUEST";
export const CONV_REQUEST_FAIL	= "CONV_REQUEST_FAIL";
export const JOINED_CONV				= "JOINED_CONV";
export const CONV_IS_LEFT				= "CONV_IS_LEFT";
export const MESSAGE_CREATED		= "MESSAGE_CREATED";

export function getConversation(id) {
	return (dispatch) => {
		dispatch({
			type: START_CONV_REQUEST
		});

		api.get(`/conversations/${id}`)
			.then((response) => {
				dispatch({
					type: GET_CONV_SUCCESS,
					payload: response
				});
			})
			.catch((error) => {
				dispatch({
					type: CONV_REQUEST_FAIL,
					payload: error.response
				});
			})
	}
}

export function joinConversation(socket, id) {
  return (dispatch) => {
    if (!socket) { return false; }

    const channel = socket.channel(`conversations:${id}`);

    channel.on('message_created', (message) => {
      dispatch({ 
      	type: MESSAGE_CREATED, 
      	message 
      });
		});

    channel.join().receive('ok', (response) => {
      dispatch({
      	type: 		JOINED_CONV,
      	payload: 	response,
      	channel: 	channel
      });
    });

    return false;
	}
}

export function leaveConversation(channel) {
  return (dispatch) => {
    if (channel) {
      channel.leave();
    }
    dispatch({
    	type: CONV_IS_LEFT
    });
  };
}

export function sendMessage(channel, data) {
  return dispatch => new Promise((resolve, reject) => {
    channel.push('new_message', data)
      .receive('ok', () => resolve())
      .receive('error', () => reject());
  });
}