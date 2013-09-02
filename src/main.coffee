possAct = (f) ->
  if typeof(Em) == 'undefined'
    f
  else
    f()

console.mylog = (str) ->
  #console.debug str
  3

setupAuthUrls = ->
  DS.RESTAdapter.reopen
    buildURL: (record, suffix) ->
      if record == 'user'
        record = "ember_user" 
        s = @._super(record, suffix)
        s + ".json"
      else
        @._super(record, suffix)

setupHashType = ->
  DS.RESTAdapter.registerTransform 'hash',
    serialize: (value) -> value
    deserialize: (value) -> value

getControllers = ->
  res = require("./controllers/sign_in")
  res = $.extend res, require("./controllers/register")
  res

auth = 
  foo: -> return 14

  double: (x) ->
    return x * 2

  controllers: possAct -> getControllers()
  models: possAct -> require("./models/user")
  Auth: possAct -> require("./auth_setup")
  #setup: require './module_setup'

  setupApp: (app,ops) ->
    app.User = @models.User
    app.SignInController = @controllers.SignInController
    app.SignOutController = @controllers.SignOutController
    app.RegisterController = @controllers.RegisterController
    app.Auth = @Auth.Auth(ops)
    require("./templates")
    #setupAuthUrls()
    setupHashType()

  registerOps: (ops) ->
    @defaultOps = ops
  getDefaultOps: ->
    @defaultOps || {}

if typeof(window) != 'undefined'
  window.EmberAuth = auth 

Em.Auth.Request.MyDummy = Em.Object.extend
  validCreds: (email,password) ->
    if email == "user@fake.com" && password == 'password123'
      true
    else
      false

  signIn: (url, opts = {}) ->
    console.mylog "sign in opts"
    console.mylog opts

    @send(opts)

    if @validCreds(opts.data.email,opts.data.password)
      @auth.trigger 'signInSuccess'
      App.Auth.set 'user', App.User.createRecord(email: opts.data.email, id: 1, auth_token: "token123")
    else
      @auth.trigger 'signInError'
    @auth.trigger 'signInComplete'
    {email: opts.data.email, id: 1, auth_token: "token123"}

  signOut: (url, opts = {}) ->
    @send opts
    switch opts.status
      when 'success' then @auth.trigger 'signOutSuccess'
      when 'error'   then @auth.trigger 'signOutError'
    @auth.trigger 'signOutComplete'

  send: (opts = {}) ->
    console.mylog "MyDummy send"
    console.mylog opts
    Em.Auth.Request.MyDummy.addSendOpts(opts)
    
    res = {}
    for k,v of opts
      res[k] = v
    res
    if @validCreds(opts.data.email,opts.data.password)
      res.auth_token = "token123"

    @auth._response.canonicalize res

Em.Auth.Request.MyDummy.reopenClass
  addSendOpts: (ops) ->
    @getOptsList().push(ops)
  getOptsList: ->
    @optsList ||= []
    @optsList
  clearOptsList: ->
    @optsList = []

module.exports = auth