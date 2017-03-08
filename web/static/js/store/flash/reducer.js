import { SET_FLASH_MESSAGE, RESET_FLASH } from './actions';

const INITIAL_STATE = {
	message: 	"",
	type: 		null
}

export default function(state = INITIAL_STATE, action){
	switch(action.type) {
	case SET_FLASH_MESSAGE:
		return { ...state, message: action.message.value, type: action.message.type };
	case RESET_FLASH:
		return INITIAL_STATE;
	default:
		return state;
	}
}