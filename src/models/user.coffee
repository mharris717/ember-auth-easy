App = {}

App.User = DS.Model.extend
  email: DS.attr('string')
  authentication_token: DS.attr('string')
  providers: DS.attr("hash")

App.User.reopenClass
  double: (x) ->
    x*2

App.User.FIXTURES = [{id: 1, email: "mharris717@gmail.com"}]

module.exports = App