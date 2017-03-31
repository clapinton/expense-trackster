import React from 'react';
import ReactDOM from 'react-dom';
import Root from './components/root';


document.addEventListener("DOMContentLoaded", () => {
  const rootEl = document.getElementById("root");
  let preloadedState = {};

  //We need this to keep the user logged in, even if they refresh the page (user bootstraping)
  if (window.currentUser) {
    preloadedState = {
      session: {
        currentUser: window.currentUser,
        errors: []
      }
    }
  };

  ReactDOM.render(<Root store={preloadedState} />, rootEl);


});
