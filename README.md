# Ember Auth Easy

Simple library to do token authentication in Ember.js. 

### Including in your project

Just include dist/ember-auth-easy.js in your project after including Ember, Ember Data, and Ember Auth.

Ember Auth Easy is also available as an npm module.

### How to use

After including ember-auth-easy.js and creating your App, call EmberAuth.setupApp

    EmberAuth.setupApp(App)

This does the following:
# Adds controllers for sign in and sign out.
# Adds a User model
# Sets the Auth value on your app
# Adds several templates for sign in/sign out (which can be overriden).
# Sets up the Auth object with reasonable defaults.

