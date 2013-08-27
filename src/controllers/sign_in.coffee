Appx = {}

Appx.SignInController = Em.ObjectController.extend
  init: ->
    @_super()
    @set "content",Em.Object.create()

  login: ->
    App.Auth.signIn
      data: 
        "email": @$email
        "password": @$password
    console.debug 'here place'

  double: (x) ->
    x*2

  dropboxUrl: (-> "#{App.getServerUrl()}/users/auth/dropbox").property()

Appx.SignOutController = Em.ObjectController.extend
  init: ->
    @_super()
    @set "content",Em.Object.create()

  logout: ->
    console.debug "logout"
    App.Auth.get("_session").clear()
    App.Auth.trigger "signOutSuccess"

module.exports = Appx