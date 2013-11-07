`import Widget from 'appkit/models/widget'`

module 'Acceptances - Register', 
  setup: ->
    EmberAuth.testHelpers.setup ->
      Widget.setupFixtures()

test 'open register form', ->
  visit("/register").then ->
    equal find(".register-form").length,1
    equal find(".register-form input").length,2

test 'submit registration', ->
  email = "user#{parseInt(Math.random()*10000000000000)}@fake.com"
  visit("/register")
  .fillIn(".register-form .email-field input",email)
  .fillIn(".register-form .password-field input","password123")
  .click(".register-form button").then ->
    equal find(".registered").text().trim(),"Successfully Registered"
    App.__container__.lookup("store:main").find('user').then (users) ->
      equal users.get('length'),2
      equal users.objectAt(0).get('email'),email
    wait()