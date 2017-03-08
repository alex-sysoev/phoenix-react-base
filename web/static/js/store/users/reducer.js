import {
	START_USERS_REQUEST,
	GET_USERS_SUCCESS,
	GET_USERS_FAIL,
	GET_USER_SUCCESS,
	UPDATE_USER_FAIL
} from './actions';

import { RESET_API_ERRORS } from '../actions';

const INITIAL_STATE = {
	collection: [],
	instance: null,
	errors: [],
	fetching: false,
	page: null,
	totalPages: null
};

export default function(state = INITIAL_STATE, action) {
	switch (action.type) {
	case START_USERS_REQUEST:
		return { ...state, fetching: true };
	case GET_USERS_SUCCESS:
		return { 
			...state, 
			collection: action.payload.data.users, 
			fetching: false,
			page: action.payload.data.page,
			totalPages: action.payload.data.total_pages 
		};
	case GET_USER_SUCCESS:
		return { ...state, instance: action.payload.data, fetching: false };
	case GET_USERS_FAIL:
		return { ...state, errors: action.payload.data, fetching: false };
	case UPDATE_USER_FAIL:
		return { ...state, errors: action.payload.data.errors, fetching: false };
	case RESET_API_ERRORS:
		return { ...state, errors: [] };
	default:
		return state;
	}
}