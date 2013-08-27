Appx = {}

Appx.SignInController = Em.ObjectController.extend
  init: ->
    @_super()
    @set "content",Em.Object.create()

  addlLoginOps: -> 
    console.debug "in empty addlLoginOps"
    {}

  login: ->
    console.debug "in login"
    ops = 
      data: 
        "email": @$email
        "password": @$password
    for k,v of @addlLoginOps()
      ops[k] = v

    App.Auth.signIn(ops)

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