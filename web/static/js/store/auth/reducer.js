import { 
	AUTH_SUCCESS, 
	AUTH_FAIL, 
	AUTH_START, 
	LOGOUT, 
	SIGN_UP_FAIL, 
	SIGN_UP_START,
	LOGIN_FAIL,
	SOCKET_CONNECTED
} from './actions';

import { RESET_API_ERRORS } from '../actions';

const INITIAL_STATE = { 
	currentUser: null,
	socket: null, 
	errors: [], 
	authenticated: false,
	fetching: false,
	isAdmin: false
};

export default function(state = INITIAL_STATE, action) {
	switch(action.type) {
	case SIGN_UP_START:
		return { ...state, fetching: true };
	case SIGN_UP_FAIL:
		return { 
			...state, 
			errors: action.payload.data.errors, 
			fetching: false,
			isAdmin: false
		};
	case AUTH_START:
		return { ...state, fetching: true };
	case AUTH_SUCCESS:
		return { 
			...state, 
			currentUser: action.payload.data.user, 
			authenticated: true, 
			fetching: false,
			isAdmin: action.payload.data.user.roles.map(r => r.name).includes("admin") 
		};
	case AUTH_FAIL:
		return { ...state, fetching: false, isAdmin: false };
	case LOGIN_FAIL:
		return { ...state, errors: ["unauthenticated"], isAdmin: false }
	case LOGOUT:
		return INITIAL_STATE;
	case RESET_API_ERRORS:
		return { ...state, errors: [] };
	case SOCKET_CONNECTED:
		return { ...state, socket: action.socket };
	default:
		return state;
	}
}