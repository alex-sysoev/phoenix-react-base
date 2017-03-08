import { combineReducers } 				from 'redux';
import AuthReducer 								from './auth/reducer';
import UsersReducer 							from './users/reducer';
import FlashReducer								from './flash/reducer';
import ConversationReducer				from './conversations/reducer'
import { reducer as formReducer } from 'redux-form';

const rootReducer = combineReducers({
	auth: 					AuthReducer,
	form: 					formReducer,
	users: 					UsersReducer,
	flash:  				FlashReducer,
	conversations: 	ConversationReducer
});

export default rootReducer;