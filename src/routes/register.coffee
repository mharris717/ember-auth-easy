RegisterRoute = Em.Route.extend
  model: ->
    console.debug "in register route"
    if @store
      @store.createRecord('user')
    else
      throw "No store in RegisterRoute"

module.exports = RegisterRoute