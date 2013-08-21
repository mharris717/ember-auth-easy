require "./module_setup"


auth = 
  foo: -> return 14

  double: (x) ->
    return x * 2

  controllers: require("./controllers/sign_in")
  models: require("./models/user")
  Auth: require("./auth_setup")

module.exports = auth