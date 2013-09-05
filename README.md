# Ember Auth Easy

Simple library to do token authentication in Ember.js. 

Corresponding Rails Engine: [Ember Auth Rails](https://github.com/mharris717/ember_auth_rails)

### Including in your project

Just include dist/ember-auth-easy.js in your project after including Ember, Ember Data, and Ember Auth.

Ember Auth Easy is also available as an npm module.

### How to use

After including ember-auth-easy.js and creating your App, call EmberAuth.setupApp and EmberAuth.setupRouter

```javascript
// If your ember app is on the same url as your server    
EmberAuth.setupApp(App);

// If your ember app is on a different url
EmberAuth.setupApp(App, {baseUrl: "http://serverurl.com"});

// Add routes
App.Router.map(function() {
  .....
  EmberAuth.setupRouter(this);
});
```

This does the following:
* Adds controllers for sign in and sign out.
* Adds a User model.
* Sets the Auth value on your app.
* Adds several templates for sign in/sign out (which can be overriden).
* Sets up the Auth object with reasonable defaults.
* Adds appropriate routes.

Once a user logs in, all subsequent requests have an auth_token parameter added to them. 