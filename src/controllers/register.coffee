Appx = {}

Appx.RegisterController = Em.ObjectController.extend
  init: ->
    @_super()
    #u = App.User.createRecord(email: "user2@fake.com", password: "password123")
    u = @get('store').createRecord(App.User,{})
    u.on 'didCreate', =>
      App.Router.router.transitionTo("registered")

    @set 'content',u

  actions: 
    register: ->
      App.RegisterController.justRegistered = @get('content')
      @get('content').save()

module.exports = Appx