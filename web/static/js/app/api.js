import axios      from 'axios';
import { CONFIG } from './config';

export const API_URL    = CONFIG.apiUrl;
export const SOCKET_URL = CONFIG.socketUrl;

function headers() {
	const token = JSON.parse(localStorage.getItem('token'));

	return {
		Accept: 'application/json',
		'Content-Type': 'application/json',
		Authorization: `Bearer ${token}`
	}
}

function parseResponse(response) {
  return response.json()
  	.then((json) => {
    	if (!response.ok) {
      	return Promise.reject(json);
    	}

    	return json;
  	});
}

function queryString(params) {
  const query = Object.keys(params).map(k => {
  	return `${encodeURIComponent(k)}=${encodeURIComponent(params[k])}`
  }).join('&');

  return `${query.length ? '?' : ''}${query}`;
}

export default {
  get(url, params = {}) {
    return axios({
    	url: 		`${API_URL}${url}${queryString(params)}`,
      method: 'GET',
      headers: headers()
    })
  },

  post(url, data) {
    const body = JSON.stringify(data);

    return axios({
      url: `${API_URL}${url}`,
    	method: 'POST',
    	headers: headers(),
    	data: data
    })
  },

  put(url, data) {
    const body = JSON.stringify(data);

    return axios({
    	url: 		`${API_URL}${url}`,
      method: 'PUT',
      headers: headers(),
      data: 	 data
    })
  },

  delete(url) {
    return axios({
    	url: 		`${API_URL}${url}`,
      method: 'DELETE',
      headers: headers()
    })
  },
};