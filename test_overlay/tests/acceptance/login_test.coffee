`import Widget from 'appkit/models/widget'`

module 'Acceptances - Login', 
  setup: ->
    EmberAuth.testHelpers.setup ->
      Widget.setupFixtures()

test 'widget renders', ->
  equal 2,2

loggedInTest 'login', "/widgets", ->
  equal find(".widget").length,2
  equal find(".widget:eq(0)").text().trim(),"Adam"