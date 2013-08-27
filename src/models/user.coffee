Appx = {}

Appx.User = DS.Model.extend
  email: DS.attr('string')
  authentication_token: DS.attr('string')
  providers: DS.attr("hash")

Appx.User.reopenClass
  double: (x) ->
    x*2

Appx.User.FIXTURES = [{id: 1, email: "mharris717@gmail.com"}]

module.exports = Appx