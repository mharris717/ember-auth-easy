Appx = {}

Appx.RegisterController = Em.ObjectController.extend
  init: ->
    @_super()
    @set 'content',App.User.createRecord(email: "user2@fake.com", password: "password123")

  register: ->
    DS.defaultStore.commit()

module.exports = Appx