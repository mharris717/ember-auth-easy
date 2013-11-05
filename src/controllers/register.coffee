Appx = {}

Appx.RegisterController = Em.ObjectController.extend
  init: ->
    @_super()
    u = @get('store').createRecord(App.User,{})
    @set 'content',u

  actions: 
    register: ->
      App.RegisterController.justRegistered = @get('content')
      @get('content').save().then =>
        App.__container__.lookup('router:main').transitionTo('registered')
      , => 
        throw "register save failed"

module.exports = Appx