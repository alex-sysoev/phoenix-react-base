import api, { SOCKET_URL } 	from '../../app/api';
import { reset } 						from 'redux-form';
import { Socket }						from 'phoenix';

import { 
	setErrorFlashMessage, 
	setSuccessFlashMessage 
} from '../flash/actions';

export const AUTH_START 			= "AUTH_START";
export const AUTH_SUCCESS 		= "AUTH_SUCCESS";
export const AUTH_FAIL 				= "AUTH_FAIL";
export const LOGOUT 					= "LOGOUT";
export const SIGN_UP_FAIL 		= 'SIGN_UP_FAIL';
export const SIGN_UP_START 		= 'SIGN_UP_START';
export const LOGIN_FAIL				= 'LOGIN_FAIL';
export const SOCKET_CONNECTED = 'SOCKET_CONNECTED';

export function login(data, router) {
	return (dispatch) => {
		dispatch({ 
			type: AUTH_START
		});

		api.post('/sessions', data)
			.then((response) => {
				setCurrentUser(dispatch, response);
				
				router.push('/conversation');

				dispatch(setSuccessFlashMessage(`Welcome ${response.data.user.first_name}!`));
			})
			.catch(error => {
				dispatch({
					type: LOGIN_FAIL
				});

				dispatch(setErrorFlashMessage("Incorrect email or/and password"));
			})
	}
}

export function logout(router) {
	return (dispatch) => {
		api.delete('/sessions/this')
			.then((response) => {
				localStorage.removeItem('token');
				dispatch({
					type: LOGOUT
				});
				router.push('/login');
			})
	}
}

export function authenticate() {
  return dispatch => api.get('/sessions/refresh')
    .then((response) => {
      setCurrentUser(dispatch, response);
    })
    .catch(() => {
      localStorage.removeItem('token');
      window.location = '/login';
    });
}

export function unauthenticate() {
	return (dispatch) => {
		dispatch({
			type: AUTH_FAIL
		});
	}
}

export function signUp(attrs, router) {
	return function(dispatch) {
		api.post('/registrations', { user: attrs })
			.then(response => {
				setCurrentUser(dispatch, response);
				router.push('/');
			})
			.catch(error => {
				dispatch({
					type: SIGN_UP_FAIL,
					payload: error.response
				});
			})
	}
}

export function setCurrentUser(dispatch, response) {
	localStorage.setItem('token', JSON.stringify(response.data.token));
	
	dispatch({ 
		type: AUTH_SUCCESS, 
		payload: response 
	});

	connectToSocket(dispatch);
}

function connectToSocket(dispatch) {
  const token 	= JSON.parse(localStorage.getItem('token'));
  const socket 	= new Socket(`${SOCKET_URL}/socket`, {
    params: { token },
    logger: (kind, msg, data) => { console.log(`${kind}: ${msg}`, data); }
  });
  socket.connect();
  dispatch({
  	type: 'SOCKET_CONNECTED',
  	socket 
  });
}