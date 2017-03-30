import React from 'react';
import ReactDOM from 'react-dom';
import Root from './components/root';
import configureStore from './store/store';


document.addEventListener("DOMContentLoaded", () => {
  const rootEl = document.getElementById("root");
  let store;

  //We need this to keep the user logged in, even if they refresh the page (user bootstraping)
  if (window.currentUser) {
    const preloadedState = {
      session: {
        currentUser: window.currentUser,
        errors: []
      }
    }
    store = configureStore(preloadedState);
  } else {
    store = configureStore();
  };

  ReactDOM.render(<Root store={store} />, rootEl);


});
