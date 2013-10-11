Appx = {}

Appx.User = DS.Model.extend
  email: DS.attr('string')
  authentication_token: DS.attr('string')
  password: DS.attr('string')

Appx.User.reopenClass
  double: (x) ->
    x*2

  find: (id) ->
    @store.find('user',id)



Appx.User.FIXTURES = [{id: 1, email: "mharris717@gmail.com"}]

module.exports = Appx