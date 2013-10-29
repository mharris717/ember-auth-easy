`import Widget from 'appkit/models/widget'`

module 'Acceptances - Widget', 
  setup: ->
    Ember.run ->
      App.__container__.lookup("auth:main").get("_session").clear()
      App.__container__.lookup("auth:main").trigger "signOutSuccess"
      Em.Auth.Request.MyDummy.clearOptsList()
    wait()

    Widget.setupFixtures()
    App.reset()
    wait()

  teardown: ->
    a = 42


test 'widget renders', ->
  equal 2,2

loggedInTest 'login', "/widgets", ->
  equal find(".widget").length,2
  equal find(".widget:eq(0)").text().trim(),"Adam"