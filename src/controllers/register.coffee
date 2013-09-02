Appx = {}

Appx.RegisterController = Em.ObjectController.extend
  init: ->
    @_super()
    u = App.User.createRecord(email: "user2@fake.com", password: "password123")

    u.on 'didCreate', =>
      App.Router.router.transitionTo("registered")

    @set 'content',u

  register: ->
    DS.defaultStore.commit()

module.exports = Appx