Appx = {}

Appx.SignInController = Em.ObjectController.extend
  init: ->
    @_super()
    @set "content",Em.Object.create()

  addlLoginOps: -> 
    console.mylog "in empty addlLoginOps"
    {}

  actions: 
    login: ->
      console.mylog "in login"
      ops = 
        data: 
          "email": @$email
          "password": @$password
      for k,v of @addlLoginOps()
        ops[k] = v

      console.mylog "login ops"
      console.mylog ops

      ops.store = @get('store')

      App.User.store = @store

      App.Auth.signIn(ops)

  showLoginForm: (-> true).property()

  double: (x) ->
    x*2

  dropboxUrl: (-> "#{App.getServerUrl()}/users/auth/dropbox").property()

Appx.SignOutController = Em.ObjectController.extend
  init: ->
    @_super()
    @set "content",Em.Object.create()

  actions:
    logout: ->
      console.mylog "logout"
      App.Auth.get("_session").clear()
      App.Auth.trigger "signOutSuccess"

module.exports = Appx