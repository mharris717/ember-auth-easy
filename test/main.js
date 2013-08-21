// Generated by CoffeeScript 1.6.3
(function() {
  var App, auth, setup, should, testSetup;

  should = require("should");

  setup = require("../lib/module_setup");

  testSetup = require("../lib/test_setup");

  testSetup.setup();

  setup.loadVendorLibs();

  setup.loadEmberAuth();

  auth = require("../lib/main");

  App = window.App = Em.Application.create();

  App.Store = DS.Store.extend({
    revision: 11,
    adapter: 'DS.RESTAdapter'
  });

  describe("ember auth", function() {
    it("smoke", function() {
      var num;
      num = 2;
      return num.should.eql(2);
    });
    it("call on mod", function() {
      return auth.foo().should.eql(14);
    });
    it("double", function() {
      return auth.double(4).should.eql(8);
    });
    it('controller', function() {
      var c;
      c = auth.controllers.SignInController.create();
      return c.double(7).should.eql(14);
    });
    return it('user model', function() {
      return auth.models.User.double(4).should.eql(8);
    });
  });

}).call(this);
