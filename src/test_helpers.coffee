helpers = {}

helpers.loginWith = (email,password,url) ->
  if !url 
    url = "/"

  visit(url)
  .fillIn(".login-form .email-field input",email)
  .fillIn(".login-form .password-field input",password)
  .click(".login-form button")

helpers.loginSuccessfully = (url) ->
  helpers.loginWith("user@fake.com","password123",url)

helpers.loginFail = ->
  helpers.loginWith("user@fake.com","passwordwrong")

helpers.register = (email,password) ->
  visit("/register")
  .fillIn(".register-form .email-field input",email)
  .fillIn(".register-form .password-field input",password)
  .click(".register-form button")

helpers.loggedInTest = (name) ->
  f = arguments[1]
  url = null

  if arguments.length == 3
    f = arguments[2]
    url = arguments[1]

  test name, ->
    helpers.loginSuccessfully(url).then(f)

helpers.setup = (callback) ->
  Ember.run ->
    App.__container__.lookup("auth:main").get("_session").clear()
    App.__container__.lookup("auth:main").trigger "signOutSuccess"
    Em.Auth.Request.MyDummy.clearOptsList()
  wait()

  callback() if callback

  App.reset()
  wait()

module.exports = helpers