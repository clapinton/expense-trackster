import { combineReducers } from 'redux';

const AppReducer = combineReducers({

});


const RootReducer = (state, action) => {
  return AppReducer(state, action);
};

export default RootReducer;
