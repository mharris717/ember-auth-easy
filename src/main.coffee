console.mylog = (str) ->
  #console.debug str
  3

auth = 
  foo: -> return 14

  double: (x) ->
    return x * 2

  setupAuthUrls: ->
    DS.RESTAdapter.reopen
      buildURL: (record, suffix) ->
        s = @._super(record, suffix)
        if record == 'user' && !s.match(".json$")
          s += ".json"
        s

  controllers: $.extend require("./controllers/sign_in"), require("./controllers/register")
  models: require("./models/user")
  Auth: require("./auth_setup")

  setupApp: (app,ops) ->
    app.User = @models.User
    app.SignInController = @controllers.SignInController
    app.SignOutController = @controllers.SignOutController
    app.RegisterController = @controllers.RegisterController
    app.Auth = @Auth.Auth(ops)
    
    @setupAuthUrls()

  setupRouter: (router) ->
    router.route("register");
    router.route('registered');

  registerOps: (ops) ->
    @defaultOps = ops
  getDefaultOps: ->
    @defaultOps || {}

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