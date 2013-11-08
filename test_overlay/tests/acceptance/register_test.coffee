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
  EmberAuth.testHelpers.register(email,"password123").then ->
    equal find(".registered").text().trim(),"Successfully Registered"
    
    # doesn't work for server, should be a better way. Possibly findQuery
    if false
      App.__container__.lookup("store:main").find('user').then (users) ->
        equal users.get('length'),2
        equal users.objectAt(0).get('email'),email
      wait()

test 'login after registration', ->
  email = "user#{parseInt(Math.random()*10000000000000)}@fake.com"
  EmberAuth.testHelpers.register(email,"password123").then ->
    text = find(".user-status .signed-in").text().trim()
    matches = text.match("Signed In as")
    equal matches.length,1
    equal matches[0],"Signed In as"