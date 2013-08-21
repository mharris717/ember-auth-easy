#require "./module_setup"

possAct = (f) ->
  if typeof(Em) == 'undefined'
    f
  else
    f()

auth = 
  foo: -> return 14

  double: (x) ->
    return x * 2

  controllers: possAct -> require("./controllers/sign_in")
  models: possAct -> require("./models/user")
  Auth: possAct -> require("./auth_setup")
  setup: require './module_setup'

  setupApp: (app) ->
    app.User = @models.User
    app.SignInController = @controllers.SignInController
    app.SignOutController = @controllers.SignOutController
    app.Auth = @Auth

module.exports = auth