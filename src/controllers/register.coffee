Appx = {}

Appx.RegisterController = Em.ObjectController.extend
  init: ->
    @_super()
    #u = App.User.createRecord(email: "user2@fake.com", password: "password123")
    u = @get('store').createRecord(App.User,{email: "user2@fake.com", password: "password123"})
    u.on 'didCreate', =>
      App.Router.router.transitionTo("registered")

    @set 'content',u

  register: ->
    @get('store').commit()

module.exports = Appx