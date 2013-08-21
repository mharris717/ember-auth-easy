App = {}

App.SignInController = Em.ObjectController.extend
  init: ->
    @_super()
    @set "content",Em.Object.create()

  login: ->
    App.Auth.signIn
      data: 
        "email": @$email
        "password": @$password

  double: (x) ->
    x*2

  dropboxUrl: (-> "http://cnn.com").property()

App.SignOutController = Em.ObjectController.extend
  init: ->
    @_super()
    @set "content",Em.Object.create()

  logout: ->
    console.debug "logout"
    App.Auth.get("_session").clear()
    App.Auth.trigger "signOutSuccess"

module.exports = App