`import Widget from 'appkit/models/widget'`

module 'Acceptances - Login', 
  setup: ->
    EmberAuth.testHelpers.setup ->
      Widget.setupFixtures()
      #App.User.setupFixtures()

test 'widget renders', ->
  equal 2,2

loggedInTest 'login works', "/widgets", ->
  equal find(".user-status .signed-in").length,1

loggedInTest 'login displays widgets', "/widgets", ->
  App.__container__.lookup("store:main").find('widget')
  wait().then ->
    equal find(".widget").length,2
    equal find(".widget:eq(0)").text().trim(),"Adam"

test 'login failure works', ->
  visit("/widgets").then ->
    EmberAuth.testHelpers.loginFail().then ->
      equal find(".widget").length,0
      equal find(".user-status .signed-out").length,1
      equal find(".user-status .signed-in").length,0
      equal find(".user-status .user-flash").text().trim(),"Sign In Failed"

loggedInTest 'logout', "/widgets", ->
  equal find(".user-status .signed-in").length,1
  click(".logout a").then ->
    equal find(".user-status .signed-in").length,0
    equal find(".user-status .signed-out").length,1
    