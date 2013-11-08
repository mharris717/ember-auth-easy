Appx = {}

Appx.RegisterController = Em.ObjectController.extend
  signInAfterRegistering: (pass) ->
    ops =
      data:
        "user":
          "email": @get('content.email')
          "password": pass
    ops.store = @get('store')
    console.debug ops

    @auth.signIn(ops)

  actions: 
    register: ->
      console.debug "register action"
      App.RegisterController.justRegistered = @get('content')
      pass = @get('content.password')

      @get('content').save().then =>
        App.__container__.lookup('router:main').transitionTo('registered')
        @signInAfterRegistering(pass)
      , => 
        throw "register save failed"

module.exports = Appx