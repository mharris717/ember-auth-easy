console.mylog = (str) ->
  console.debug str
  3

getBaseObjs = ->
  res = {}
  res = $.extend res, require("./controllers/sign_in")
  res = $.extend res, require("./controllers/register")
  res = $.extend res, require("./models/user")
  res.RegisterRoute = require("./routes/register")
  res

baseObjs = getBaseObjs()

auth = 
  setupAuthUrls: ->
    DS.RESTAdapter.reopen
      buildURL: (record, suffix) ->
        s = @._super(record, suffix)
        if record == 'user' && !s.match(".json$")
          s += ".json"
        s

  Auth: require("./auth_setup")
  testHelpers: require("./test_helpers")

  setupApp: (app,ops) ->
    app.User = baseObjs.User
    app.SignInController = baseObjs.SignInController
    app.SignOutController = baseObjs.SignOutController
    app.RegisterController = baseObjs.RegisterController
    app.RegisterRoute = baseObjs.RegisterRoute

    authClass = @Auth.Auth(ops)
    
    @setupAuthUrls()

    app.register "auth:main",authClass
    app.inject "controller","auth","auth:main"

  setupRouter: (router) ->
    router.route("register");
    router.route('registered');

  registerOps: (ops) ->
    @defaultOps ||= {}
    for k,v of ops
      @defaultOps[k] = v

  getDefaultOps: ->
    @defaultOps || {}

for k,v of baseObjs
  auth[k] = v

setupEmberInit = ->
  Ember.onLoad 'Ember.Application', (Application) ->
    Application.initializer
      name: "ember-auth-easy"
      initialize: (container, app) ->
        auth.setupApp(app,auth.getDefaultOps())
        app.Router.map ->
          auth.setupRouter(this)

setupEmberInit()

if typeof(window) != 'undefined'
  window.EmberAuth = auth 

require("./dummy_request")
require("./templates")

module.exports = auth