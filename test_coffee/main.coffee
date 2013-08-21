should = require("should")
auth = require("../lib/main")

App = window.App = Em.Application.create()

App.Store = DS.Store.extend
  revision: 11
  adapter: 'DS.RESTAdapter'


describe "ember auth", ->
  it "smoke", ->
    num = 2;
    num.should.eql 2

  it "call on mod", ->
    auth.foo().should.eql 14

  it "double", ->
    auth.double(4).should.eql 8

  it 'controller', ->
    c = auth.controllers.SignInController.create()
    c.double(7).should.eql(14)

  it 'user model', ->
    auth.models.User.double(4).should.eql(8)
