var mode = null;
window.testingMode = function() {
  var runCallback, setMode;
  runCallback = function(isolated, server) {
    if (mode === "server") {
      if (server) {
        return server();
      }
    } else if (mode === "isolated") {
      if (isolated) {
        return isolated();
      }
    }
    else {
      throw "Bad mode";
    }
  };
  setMode = function(newMode) {
    return mode = newMode;
  };
  if (arguments.length === 2) {
    return runCallback(arguments[0], arguments[1]);
  } else if (arguments.length === 1 && arguments[0].trim) {
    return setMode(arguments[0]);
  } else if (arguments.length === 1) {
    return runCallback(arguments[0].isolated, arguments[0].server);
  } else if (arguments.length === 0) {
    return mode;
  } else {
    throw "bad args";
  }
};

testingMode("isolated");

testingMode({
  isolated: function() {
    return EmberAuth.registerOps({
      requestAdapter: "MyDummy",
      modules: ["emberData"]
    });
  },
  server: function() {
    return EmberAuth.registerOps({
      baseUrl: "http://localhost:5901",
      modules: ["emberData"]
    });
  }
});
