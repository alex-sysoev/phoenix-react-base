import api from '../../app/api'

import { 
	setErrorFlashMessage, 
	setSuccessFlashMessage 
} from '../flash/actions';

export const START_USERS_REQUEST = "START_USERS_REQUEST";
export const GET_USERS_FAIL 		 = "GET_USERS_FAIL";
export const GET_USERS_SUCCESS 	 = "GET_USERS_SUCCESS";
export const GET_USER_SUCCESS    = "GET_USER_SUCCESS";
export const UPDATE_USER_FAIL    = "UPDATE_USER_FAIL";

export function getUsers(options = {}) {
	return (dispatch) => {
		dispatch({
			type: START_USERS_REQUEST
		});

		api.get('/users', options)
			.then((response) => {
				dispatch({
					type: GET_USERS_SUCCESS,
					payload: response
				});
			})
			.catch((error) => {
				dispatch({
					type: GET_USERS_FAIL,
					payload: error.response
				});
			})
	}
}

export function getUser(id) {
	return (dispatch) => {
		dispatch({
			type: START_USERS_REQUEST
		});

		api.get(`/users/${id}`)
			.then((response) => {
				dispatch({
					type: GET_USER_SUCCESS,
					payload: response
				});
			})
			.catch((error) => {
				dispatch({
					type: GET_USERS_FAIL,
					payload: error.response
				});
			})
	}
}

export function updateUser(id, data, router, path) {
	return (dispatch) => {
		dispatch({
			type: START_USERS_REQUEST
		});

		api.put(`/users/${id}`, {user: data})
			.then(response => {
				dispatch({
					type: GET_USER_SUCCESS,
					payload: response
				});

				if (router && path) {
					router.push(path);
				}

				dispatch(setSuccessFlashMessage("Successfully updated"));
			})
			.catch(error => {
				dispatch({
					type: UPDATE_USER_FAIL,
					payload: error.response
				});

				dispatch(setErrorFlashMessage("Something went wrong"));
			})
	}
}

export function deleteUser(id) {
	return (dispatch) => {
		dispatch({
			type: START_USERS_REQUEST
		});

		api.delete(`/users/${id}`)
			.then((response) => {
				dispatch(setSuccessFlashMessage("Successfully deleted"));
				dispatch(getUsers());
			})
			.catch((error) => {
				dispatch({
					type: GET_USERS_FAIL,
					payload: error.response
				});
			})
	}
}