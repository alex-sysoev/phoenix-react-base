import {
	GET_CONV_SUCCESS,
	START_CONV_REQUEST,
	CONV_REQUEST_FAIL,
	JOINED_CONV,
	CONV_IS_LEFT,
	MESSAGE_CREATED
} from './actions';

const INITIAL_STATE = {
	collection: [],
	instance: null,
	errors: [],
	fetching: false,
	channel: null
}

export default function(state = INITIAL_STATE, action) {
	switch (action.type) {
		case START_CONV_REQUEST:
			return { ...state, fetching: true };
		case GET_CONV_SUCCESS:
			return { ...state, instance: action.payload.data, fetching: false };
		case JOINED_CONV:
			return { 
				...state, 
				instance: action.payload.conversation,
				messages: action.payload.messages,
				channel: 	action.channel
			};
		case MESSAGE_CREATED:
			return {
				...state,
				messages: [...state.messages, action.message]
			};
		case CONV_IS_LEFT:
			return INITIAL_STATE;
		default:
			return state;
	}
}