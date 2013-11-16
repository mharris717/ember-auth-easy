UserStatusController = Em.ObjectController.extend
  init: ->
    @set "content",Em.Object.create()
    @auth.on "signInError", =>
      console.debug "failure callback in user status controller"
      @set "flash","Sign In Failed"
    @auth.on "signInSuccess", =>
      console.debug "failure callback in user status controller"
      @set "flash",""

module.exports = UserStatusController