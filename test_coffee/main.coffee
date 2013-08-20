should = require("should")
auth = require("../lib/main")

describe "ember auth", ->
  it "smoke", ->
    num = 2;
    num.should.eql 2

  it "call on mod", ->
    auth.foo().should.eql 14

  it "double", ->
    auth.double(4).should.eql 8
