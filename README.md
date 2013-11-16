# Ember Auth Easy

[![Build Status](https://travis-ci.org/mharris717/ember-auth-easy.png)](https://travis-ci.org/mharris717/ember-auth-easy)

Simple library to do token authentication in Ember.js. 

Corresponding Rails Engine: [Ember Auth Rails](https://github.com/mharris717/ember_auth_rails)

### Including in your project

Just include dist/ember-auth-easy.js in your project after including Ember, Ember Data, and Ember Auth.

Ember Auth Easy is also available as an npm module.

### How to use

After including ember-auth-easy.js and creating your App, the only setup required is if your ember app is on a different URL than your server

```javascript
// If your ember app is on a different url
EmberAuth.registerOps({baseUrl: "http://serverurl.com"});
```

In your template, render the user status partial:
```
  {{render user_status}}
```

This does the following:
* Adds controllers for sign in and sign out.
* Adds a User model.
* Sets the Auth value on your app.
* Adds several templates for sign in/sign out (which can be overriden).
* Sets up the Auth object with reasonable defaults.
* Adds appropriate routes.

Once a user logs in, all subsequent requests have an auth_token parameter added to them.

#### Overriding EAE Objects

To override a built in EAE object, just create a file and define your class as normal. Your class will be used instead of the default.

To override SignInController, put the following in app/controllers/sign_in.js:

```
SignInController = Ember.ObjectController.extend({
  // your code
});

export default SignInController;
```

To extend the built in instead of replacing it:
```
SignInController = EmberAuth.SignInController.extend({
  // your code
});

export default SignInController;
```

The same goes for templates.

### Developing and Improving Ember Auth Easy

Ember Auth Easy development depends upon ruby, rake and node.

Ember Auth Easy is designed to make it easy to build a new version of the tool
using 'rake dist' on the commandline. Before running 'rake dist' for the first
time install the required dependencies by executing the following commands
on the commandline:

```
bundle install
```

### Running the test app

There are several test apps included with Ember Auth Easy. 

You may need to install prereqs first:

```
bundle install
npm install
```

#### Client (Ember App Kit)

To build and run it:

```
# if not already installed
# possibly with sudo
npm install -g bower grunt-cli

bundle exec rake overlay:test
```

This will:
* Download Ember App Kit to test_overlay_app.
* Add models/controllers/routes for a Widget class.
* Overlay the files in test_overlay onto this new app.
* Build EAE and copy it into the new app.
* Start a server for the new app and run its tests. 

Once the app is built, to run the tests in the app:

```
cd test_overlay_app
grunt test:ci
```

This will run the tests in isolated mode, using the FixtureAdapter.

##### Server Mode

To run the tests in "server mode," change the following line in test_overlay_app/tests/pre_app.js:

```
//default
testingMode("isolated");

//change to
testingMode("server");
```

This will run the tests by connecting to a server on port 5901, instead of using the FixtureAdapter. This is meant to match how a real app will work as closely as possible. To start a server for testing in server mode, see the next section. 

#### Server (Rails using Ember Auth Rails)

To build and run it:

```
rake test_server:setup test_server:run
```

This will:
* Create an empty rails app in test_server.
* Add Ember Auth Rails to the app.
* Add models/controllers/routes for a Widget class.
* Setup the database.
* Run the app on port 5901