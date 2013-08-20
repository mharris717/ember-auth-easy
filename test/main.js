var should = require("should");
var auth = require("../lib/main")

describe("ember auth", function() {
  it("smoke", function() {
    var num = 2;
    num.should.eql(2);
  })

  it("call on mod", function() {
    auth.foo().should.eql(14);
  })

  it("double", function() {
    auth.double(4).should.eql(8);
  })
})