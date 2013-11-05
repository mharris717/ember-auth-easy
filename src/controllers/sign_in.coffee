Appx = {}

Appx.SignInController = Em.ObjectController.extend
  init: ->
    @_super()
    @set "content",Em.Object.create()
    @set "email","mharris717@gmail.com"
    @set "password","dfgdfgregegr"

  addlLoginOps: -> 
    console.mylog "in empty addlLoginOps"
    {}

  actions: 
    login: ->
      console.mylog "in login"
      ops =
        data:
          "user":
            "email": @$email
            "password": @$password
      for k,v of @addlLoginOps()
        ops[k] = v

      console.mylog "login ops"
      console.mylog ops

      ops.store = @get('store')

      App.User.store = @store

      @get('auth').signIn(ops)

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
      @get('auth').get("_session").clear()
      @get('auth').trigger "signOutSuccess"

module.exports = Appx