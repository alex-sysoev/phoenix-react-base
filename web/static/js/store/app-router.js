import React, { Component } 													from 'react';
import { Router, Route, IndexRoute, browserHistory } 	from 'react-router';
import { Provider } 																	from 'react-redux';
import { createStore, applyMiddleware, compose } 			from 'redux';
import reducers 																			from './reducers';
import reduxThunk 																		from 'redux-thunk';

import { unauthenticate, setCurrentUser } 						from './auth/actions';
import { resetFlash, setErrorFlashMessage } 					from './flash/actions';
import App 																						from '../screens/app';
import Registration 																	from '../screens/registration';
import Login 																					from '../screens/login';
import Users 																					from '../screens/users';
import UserEdit 																			from '../screens/user-edit';
import Profile  																			from '../screens/profile';
import Dashboard 																			from '../screens/dashboard';
import Conversation 																	from '../screens/conversation';
import NotFound																				from '../screens/not-found';
import api 																						from '../app/api';

const createStoreWithMiddleware = compose(
	applyMiddleware(
		reduxThunk
	),
	window.devToolsExtension ? window.devToolsExtension() : f => f
)(createStore);

const store = createStoreWithMiddleware(reducers);

class AppRouter extends Component {

	// Very messy authenticate function that needs to be refatored
	authenticate({role, replaceState, noAuth, auth, callback}) {
    const token = localStorage.getItem('token');
    let 	user 	= store.getState().auth.currentUser;

    if (user && token) {
    	if (role && !user.roles.map(r => r.name).includes(role)) {
    		replaceState('/');
    		store.dispatch(setErrorFlashMessage("You don't have access to this page."));
    	} else if (noAuth) {
    		replaceState('/');
    	}

    	if (callback) {
    		callback();
    	}
    } else if (!token) {
    	store.dispatch(unauthenticate());

    	if (!noAuth) {
	    	if (replaceState) {
	    		replaceState('/login');
	    	} else {
	    		window.location = '/login';
	    	}
    	}

    	if (callback) {
    		callback();
    	}	
    } else if (token && !user) {
		  api.get('/sessions/refresh')
		    .then((response) => {
					localStorage.setItem('token', JSON.stringify(response.data.token));
					user = response.data.user;

					setCurrentUser(store.dispatch, response);

			    if (noAuth && user) {
			    	replaceState('/');
			 
			    } else if (role && !user.roles.map(r => r.name).includes(role)){
				    replaceState('/');
				   	store.dispatch(setErrorFlashMessage("You don't have access to this page."));
				  }

					if (callback) {
						callback();
					}
		    })
		    .catch((error) => {
		    	console.log(error);
		      localStorage.removeItem('token');
		      
		      if (auth || role) {
		      	if (replaceState) {
		      		replaceState('/login');
		      	} else {
		      		window.location = '/login';
		      	}
		      }

		      if (callback) {
		      	callback();
		      }
		    });
    }
	}

	requireAuth(nextState, replaceState) {
		this.authenticate({auth: true, replaceState: replaceState});
	}

	requireAdminAuth(nextState, replaceState, callback) {
		this.authenticate({role: 'admin', replaceState, callback});
	}

	requireNoAuth(nextState, replaceState, callback) {
		this.authenticate({noAuth: true, replaceState, callback});
	}

	render() {
		return(
			<Provider store={store}>
				<Router history={browserHistory} onUpdate={onRouteChange}>
					<Route path="/" component={App}>
						<Route onEnter={this.requireNoAuth.bind(this)}>
							<Route path="/signup" component={Registration} />
							<Route path="/login"  component={Login} />
						</Route>
						<Route onEnter={this.requireAuth.bind(this)}>
							<IndexRoute component={Conversation} />
							<Route path="/profile"				component={Profile} />
							<Route path="/conversation"		component={Conversation} />
						</Route>
						<Route onEnter={this.requireAdminAuth.bind(this)}>
							<Route path="/admin" 								component={Dashboard} />
							<Route path="/admin/users"  				component={Users} />
							<Route path="/admin/users/:id/edit" component={UserEdit} />
						</Route>
					</Route>
					<Route path="*" component={NotFound} />
				</Router>
			</Provider>
		);
	}

}

function onRouteChange() {
	if (store.getState().flash.message.length > 0) {
		//store.dispatch(resetFlash());
	}
}

export default AppRouter;