App = {}

App.Auth = Em.Auth.create
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

App.Auth.on "signInSuccess", ->
  console.debug "signed in"
  setTimeout ->
    classes = App.$userRefreshClasses
    if classes
      for c in classes
        c.find()
  ,1000

module.exports = App