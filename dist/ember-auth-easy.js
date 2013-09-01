;(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
// Generated by CoffeeScript 1.6.3
(function() {
  var Appx;

  Appx = {};

  Appx.Auth = function(overrideOps) {
    var a, defaults, k, ops, v;
    defaults = {
      signInEndPoint: '/users/sign_in.json',
      signOutEndPoint: '/logout',
      userModel: 'App.User',
      tokenKey: "auth_token",
      tokenIdKey: "user_id",
      sessionAdapter: 'cookie',
      modules: ['emberData', 'rememberable'],
      rememberable: {
        tokenKey: 'auth_token',
        period: 14,
        autoRecall: true
      }
    };
    ops = defaults;
    if (overrideOps) {
      for (k in overrideOps) {
        v = overrideOps[k];
        ops[k] = v;
      }
    }
    a = Em.Auth.create(ops);
    a.on("signInSuccess", function() {
      console.mylog("signed in");
      return setTimeout(function() {
        var c, classes, _i, _len, _results;
        classes = App.get('userRefreshClasses');
        if (classes) {
          _results = [];
          for (_i = 0, _len = classes.length; _i < _len; _i++) {
            c = classes[_i];
            _results.push(c.find());
          }
          return _results;
        }
      }, 1000);
    });
    a.on('signInError', function(a) {
      var resp;
      resp = App.Auth.get('response');
      return console.mylog("sign in error " + resp);
    });
    return a;
  };

  module.exports = Appx;

}).call(this);

},{}],2:[function(require,module,exports){
// Generated by CoffeeScript 1.6.3
(function() {
  var Appx;

  Appx = {};

  Appx.SignInController = Em.ObjectController.extend({
    init: function() {
      this._super();
      return this.set("content", Em.Object.create());
    },
    addlLoginOps: function() {
      console.mylog("in empty addlLoginOps");
      return {};
    },
    login: function() {
      var k, ops, v, _ref;
      console.mylog("in login");
      ops = {
        data: {
          "email": this.get('email'),
          "password": this.get('password')
        }
      };
      _ref = this.addlLoginOps();
      for (k in _ref) {
        v = _ref[k];
        ops[k] = v;
      }
      console.mylog("login ops");
      console.mylog(ops);
      return App.Auth.signIn(ops);
    },
    showLoginForm: (function() {
      return true;
    }).property(),
    double: function(x) {
      return x * 2;
    },
    dropboxUrl: (function() {
      return "" + (App.getServerUrl()) + "/users/auth/dropbox";
    }).property()
  });

  Appx.SignOutController = Em.ObjectController.extend({
    init: function() {
      this._super();
      return this.set("content", Em.Object.create());
    },
    logout: function() {
      console.mylog("logout");
      App.Auth.get("_session").clear();
      return App.Auth.trigger("signOutSuccess");
    }
  });

  module.exports = Appx;

}).call(this);

},{}],3:[function(require,module,exports){
// Generated by CoffeeScript 1.6.3
(function() {
  var auth, possAct, setupAuthUrls, setupHashType;

  possAct = function(f) {
    if (typeof Em === 'undefined') {
      return f;
    } else {
      return f();
    }
  };

  console.mylog = function(str) {
    return 3;
  };

  setupAuthUrls = function() {
    return DS.RESTAdapter.reopen({
      buildURL: function(record, suffix) {
        var s;
        if (record === 'user') {
          record = "ember_user";
          s = this._super(record, suffix);
          return s + ".json";
        } else {
          return this._super(record, suffix);
        }
      }
    });
  };

  setupHashType = function() {
    return DS.RESTAdapter.registerTransform('hash', {
      serialize: function(value) {
        return value;
      },
      deserialize: function(value) {
        return value;
      }
    });
  };

  auth = {
    foo: function() {
      return 14;
    },
    double: function(x) {
      return x * 2;
    },
    controllers: possAct(function() {
      return require("./controllers/sign_in");
    }),
    models: possAct(function() {
      return require("./models/user");
    }),
    Auth: possAct(function() {
      return require("./auth_setup");
    }),
    setupApp: function(app, ops) {
      app.User = this.models.User;
      app.SignInController = this.controllers.SignInController;
      app.SignOutController = this.controllers.SignOutController;
      app.Auth = this.Auth.Auth(ops);
      require("./templates");
      return setupHashType();
    },
    registerOps: function(ops) {
      return this.defaultOps = ops;
    },
    getDefaultOps: function() {
      return this.defaultOps || {};
    }
  };

  if (typeof window !== 'undefined') {
    window.EmberAuth = auth;
  }

  Em.Auth.Request.MyDummy = Em.Object.extend({
    validCreds: function(email, password) {
      if (email === "user@fake.com" && password === 'password123') {
        return true;
      } else {
        return false;
      }
    },
    signIn: function(url, opts) {
      if (opts == null) {
        opts = {};
      }
      console.mylog("sign in opts");
      console.mylog(opts);
      this.send(opts);
      if (this.validCreds(opts.data.email, opts.data.password)) {
        this.auth.trigger('signInSuccess');
        App.Auth.set('user', App.User.createRecord({
          email: opts.data.email,
          id: 1,
          auth_token: "token123"
        }));
      } else {
        this.auth.trigger('signInError');
      }
      this.auth.trigger('signInComplete');
      return {
        email: opts.data.email,
        id: 1,
        auth_token: "token123"
      };
    },
    signOut: function(url, opts) {
      if (opts == null) {
        opts = {};
      }
      this.send(opts);
      switch (opts.status) {
        case 'success':
          this.auth.trigger('signOutSuccess');
          break;
        case 'error':
          this.auth.trigger('signOutError');
      }
      return this.auth.trigger('signOutComplete');
    },
    send: function(opts) {
      var k, res, v;
      if (opts == null) {
        opts = {};
      }
      console.mylog("MyDummy send");
      console.mylog(opts);
      Em.Auth.Request.MyDummy.addSendOpts(opts);
      res = {};
      for (k in opts) {
        v = opts[k];
        res[k] = v;
      }
      res;
      if (this.validCreds(opts.data.email, opts.data.password)) {
        res.auth_token = "token123";
      }
      return this.auth._response.canonicalize(res);
    }
  });

  Em.Auth.Request.MyDummy.reopenClass({
    addSendOpts: function(ops) {
      return this.getOptsList().push(ops);
    },
    getOptsList: function() {
      this.optsList || (this.optsList = []);
      return this.optsList;
    },
    clearOptsList: function() {
      return this.optsList = [];
    }
  });

  module.exports = auth;

}).call(this);

},{"./auth_setup":1,"./controllers/sign_in":2,"./models/user":4,"./templates":5}],4:[function(require,module,exports){
// Generated by CoffeeScript 1.6.3
(function() {
  var Appx;

  Appx = {};

  Appx.User = DS.Model.extend({
    email: DS.attr('string'),
    authentication_token: DS.attr('string'),
    providers: DS.attr("hash")
  });

  Appx.User.reopenClass({
    double: function(x) {
      return x * 2;
    }
  });

  Appx.User.FIXTURES = [
    {
      id: 1,
      email: "mharris717@gmail.com"
    }
  ];

  module.exports = Appx;

}).call(this);

},{}],5:[function(require,module,exports){
Em.TEMPLATES['_user_status'] = Em.Handlebars.compile('<span class="user-status">   {{#if App.Auth.signedIn}}     Signed In as {{App.Auth.user.email}}     {{render sign_out}}   {{else}}     {{render sign_in}}   {{/if}} </span>');

Em.TEMPLATES['sign_in'] = Em.Handlebars.compile('<form class="form-inline login-form">   {{#if showLoginForm}}     <span class="email-field">       {{view Em.TextField valueBinding="email" placeholder="Email"}}      </span>      <span class="password-field">       {{view Em.TextField valueBinding="password" placeholder="Password"}}     </span>     <span class="submit-button">       <button {{action "login"}}>Login</button>     </span>   {{else}}     <a {{bindAttr href="dropboxUrl"}}>Login with Dropbox</a>   {{/if}} </form>');

Em.TEMPLATES['sign_out'] = Em.Handlebars.compile('<a href="#" {{action "logout"}}>Logout</a> {{#if App.Auth.user.providers.fatsecret}}    {{else}}   {{#if App.useFatSecret}}     <a {{bindAttr href="fatsecretUrl"}}>Connect FatSecret</a>   {{/if}} {{/if}}');


},{}]},{},[3])
;