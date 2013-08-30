Appx = {}

Appx.Auth = (overrideOps) ->
  defaults = 
    signInEndPoint: '/users/sign_in.json'
    signOutEndPoint: '/logout'
    userModel: 'App.User'

    tokenKey: "auth_token"
    tokenIdKey: "user_id"

    sessionAdapter: 'cookie'
    modules: ['emberData','rememberable']

    rememberable:
      tokenKey: 'auth_token'
      period: 14 # default 14
      autoRecall: true # default true

  ops = defaults
  if overrideOps
    for k,v of overrideOps
      ops[k] = v

  a = Em.Auth.create(ops)    

  a.on "signInSuccess", ->
    console.mylog "signed in"
    setTimeout ->
      classes = App.$userRefreshClasses
      if classes
        for c in classes
          c.find()
    ,1000

  a.on 'signInError', (a) ->
    resp = App.Auth.$response
    console.mylog "sign in error #{resp}"

  a

module.exports = Appx