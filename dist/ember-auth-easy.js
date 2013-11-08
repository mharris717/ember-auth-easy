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
    a = Em.Auth.extend(ops);
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
      resp = a.get('response');
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

  Appx.RegisterController = Em.ObjectController.extend({
    signInAfterRegistering: function(pass) {
      var ops;
      ops = {
        data: {
          "user": {
            "email": this.get('content.email'),
            "password": pass
          }
        }
      };
      ops.store = this.get('store');
      console.debug(ops);
      return this.auth.signIn(ops);
    },
    actions: {
      register: function() {
        var pass,
          _this = this;
        console.debug("register action");
        App.RegisterController.justRegistered = this.get('content');
        pass = this.get('content.password');
        return this.get('content').save().then(function() {
          App.__container__.lookup('router:main').transitionTo('registered');
          return _this.signInAfterRegistering(pass);
        }, function() {
          throw "register save failed";
        });
      }
    }
  });

  module.exports = Appx;

}).call(this);

},{}],3:[function(require,module,exports){
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
    actions: {
      login: function() {
        var k, ops, v, _ref;
        console.mylog("in login");
        ops = {
          data: {
            "user": {
              "email": this.get('email'),
              "password": this.get('password')
            }
          }
        };
        _ref = this.addlLoginOps();
        for (k in _ref) {
          v = _ref[k];
          ops[k] = v;
        }
        console.mylog("login ops");
        console.mylog(ops);
        ops.store = this.get('store');
        App.User.store = this.store;
        return this.get('auth').signIn(ops);
      }
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
    actions: {
      logout: function() {
        console.mylog("logout");
        this.get('auth').get("_session").clear();
        return this.get('auth').trigger("signOutSuccess");
      }
    }
  });

  module.exports = Appx;

}).call(this);

},{}],4:[function(require,module,exports){
// Generated by CoffeeScript 1.6.3
(function() {
  Em.Auth.Request.MyDummy = Em.Object.extend({
    validCreds: function(email, password) {
      if (email === "user@fake.com" && password === 'password123') {
        return true;
      } else {
        return true;
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
        this.auth.set('user', opts.store.createRecord(App.User, {
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
      var a, k, res, v;
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
      if (opts && opts.data && this.validCreds(opts.data.email, opts.data.password)) {
        res.auth_token = "token123";
      }
      if (opts && opts.url && opts.url.match("/posts")) {
        a = [];
        a.push({
          id: 1,
          title: "Fun"
        });
        a.push({
          id: 2,
          title: "More Fun"
        });
        res = {
          posts: a
        };
        console.mylog(res);
        return res;
      } else {
        return this.auth._response.canonicalize(res);
      }
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

}).call(this);

},{}],5:[function(require,module,exports){
// Generated by CoffeeScript 1.6.3
(function() {
  var auth, setupEmberInit;

  console.mylog = function(str) {
    return 3;
  };

  auth = {
    setupAuthUrls: function() {
      return DS.RESTAdapter.reopen({
        buildURL: function(record, suffix) {
          var s;
          s = this._super(record, suffix);
          if (record === 'user' && !s.match(".json$")) {
            s += ".json";
          }
          return s;
        }
      });
    },
    controllers: $.extend(require("./controllers/sign_in"), require("./controllers/register")),
    models: require("./models/user"),
    Auth: require("./auth_setup"),
    testHelpers: require("./test_helpers"),
    setupApp: function(app, ops) {
      var authClass;
      app.User = this.models.User;
      app.SignInController = this.controllers.SignInController;
      app.SignOutController = this.controllers.SignOutController;
      app.RegisterController = this.controllers.RegisterController;
      app.RegisterRoute = require("./routes/register");
      authClass = this.Auth.Auth(ops);
      this.setupAuthUrls();
      app.register("auth:main", authClass);
      return app.inject("controller", "auth", "auth:main");
    },
    setupRouter: function(router) {
      router.route("register");
      return router.route('registered');
    },
    registerOps: function(ops) {
      var k, v, _results;
      this.defaultOps || (this.defaultOps = {});
      _results = [];
      for (k in ops) {
        v = ops[k];
        _results.push(this.defaultOps[k] = v);
      }
      return _results;
    },
    getDefaultOps: function() {
      return this.defaultOps || {};
    }
  };

  setupEmberInit = function() {
    return Ember.onLoad('Ember.Application', function(Application) {
      return Application.initializer({
        name: "ember-auth-easy",
        initialize: function(container, app) {
          auth.setupApp(app, auth.getDefaultOps());
          return app.Router.map(function() {
            return auth.setupRouter(this);
          });
        }
      });
    });
  };

  setupEmberInit();

  if (typeof window !== 'undefined') {
    window.EmberAuth = auth;
  }

  require("./dummy_request");

  require("./templates");

  module.exports = auth;

}).call(this);

},{"./auth_setup":1,"./controllers/register":2,"./controllers/sign_in":3,"./dummy_request":4,"./models/user":6,"./routes/register":7,"./templates":8,"./test_helpers":9}],6:[function(require,module,exports){
// Generated by CoffeeScript 1.6.3
(function() {
  var Appx;

  Appx = {};

  Appx.User = DS.Model.extend({
    email: DS.attr('string'),
    authentication_token: DS.attr('string'),
    password: DS.attr('string')
  });

  Appx.User.reopenClass({
    double: function(x) {
      return x * 2;
    },
    find: function(id) {
      return this.store.find('user', id);
    }
  });

  Appx.User.FIXTURES = [
    {
      id: 1,
      email: "user@fake.com",
      password: "password123"
    }
  ];

  module.exports = Appx;

}).call(this);

},{}],7:[function(require,module,exports){
// Generated by CoffeeScript 1.6.3
(function() {
  var RegisterRoute;

  RegisterRoute = Em.Route.extend({
    model: function() {
      console.debug("in register route");
      if (this.store) {
        return this.store.createRecord('user');
      } else {
        throw "No store in RegisterRoute";
      }
    }
  });

  module.exports = RegisterRoute;

}).call(this);

},{}],8:[function(require,module,exports){
Em.TEMPLATES['_user_status'] = Em.Handlebars.compile('<span class="user-status">   {{#if auth.signedIn}}     <span class="signed-in">       Signed In as {{auth.user.email}}     </span>     {{render sign_out}}   {{else}}     {{render sign_in}}   {{/if}} </span>');

Em.TEMPLATES['-user-status'] = Em.Handlebars.compile('<span class="user-status">   {{#if auth.signedIn}}     <span class="signed-in">       Signed In as {{auth.user.email}}     </span>     {{render sign_out}}   {{else}}     {{render sign_in}}   {{/if}} </span>');

Em.TEMPLATES['user_status'] = Em.Handlebars.compile('<span class="user-status">   {{#if auth.signedIn}}     <span class="signed-in">       Signed In as {{auth.user.email}}     </span>     {{render sign_out}}   {{else}}     {{render sign_in}}   {{/if}} </span>');

Em.TEMPLATES['user-status'] = Em.Handlebars.compile('<span class="user-status">   {{#if auth.signedIn}}     <span class="signed-in">       Signed In as {{auth.user.email}}     </span>     {{render sign_out}}   {{else}}     {{render sign_in}}   {{/if}} </span>');

Em.TEMPLATES['register'] = Em.Handlebars.compile('<div class="register">   <form class="register-form">     <span class="email-field">       Email: {{view Em.TextField valueBinding="email"}}<br>     </span>      <span class="password-field">       Password: {{view Em.TextField valueBinding="password"}}<br>     </span>          <button {{action "register"}}>Register</button>   </form> </div>');

Em.TEMPLATES['registered'] = Em.Handlebars.compile('<span class="registered">   Successfully Registered </span>');

Em.TEMPLATES['sign_in'] = Em.Handlebars.compile('<form class="form-inline login-form">   {{#if showLoginForm}}     <span class="email-field">       {{view Em.TextField valueBinding="email" placeholder="Email"}}      </span>      <span class="password-field">       {{view Em.TextField valueBinding="password" placeholder="Password"}}     </span>     <span class="submit-button">       <button {{action "login"}}>Login</button>     </span>      {{#linkTo "register"}}Register{{/linkTo}}   {{else}}     <a {{bindAttr href="dropboxUrl"}}>Login with Dropbox</a>   {{/if}} </form>');

Em.TEMPLATES['sign-in'] = Em.Handlebars.compile('<form class="form-inline login-form">   {{#if showLoginForm}}     <span class="email-field">       {{view Em.TextField valueBinding="email" placeholder="Email"}}      </span>      <span class="password-field">       {{view Em.TextField valueBinding="password" placeholder="Password"}}     </span>     <span class="submit-button">       <button {{action "login"}}>Login</button>     </span>      {{#linkTo "register"}}Register{{/linkTo}}   {{else}}     <a {{bindAttr href="dropboxUrl"}}>Login with Dropbox</a>   {{/if}} </form>');

Em.TEMPLATES['sign_out'] = Em.Handlebars.compile('<a href="#" {{action "logout"}}>Logout</a> {{#if auth.user.providers.fatsecret}}    {{else}}   {{#if App.useFatSecret}}     <a {{bindAttr href="fatsecretUrl"}}>Connect FatSecret</a>   {{/if}} {{/if}}');

Em.TEMPLATES['sign-out'] = Em.Handlebars.compile('<a href="#" {{action "logout"}}>Logout</a> {{#if auth.user.providers.fatsecret}}    {{else}}   {{#if App.useFatSecret}}     <a {{bindAttr href="fatsecretUrl"}}>Connect FatSecret</a>   {{/if}} {{/if}}');


},{}],9:[function(require,module,exports){
// Generated by CoffeeScript 1.6.3
(function() {
  var helpers;

  helpers = {};

  helpers.loginWith = function(email, password, url) {
    if (!url) {
      url = "/";
    }
    return visit(url).fillIn(".login-form .email-field input", email).fillIn(".login-form .password-field input", password).click(".login-form button");
  };

  helpers.loginSuccessfully = function(url) {
    return helpers.loginWith("user@fake.com", "password123", url);
  };

  helpers.loginFail = function() {
    return helpers.loginWith("user@fake.com", "passwordwrong");
  };

  helpers.register = function(email, password) {
    return visit("/register").fillIn(".register-form .email-field input", email).fillIn(".register-form .password-field input", password).click(".register-form button");
  };

  helpers.loggedInTest = function(name) {
    var f, url;
    f = arguments[1];
    url = null;
    if (arguments.length === 3) {
      f = arguments[2];
      url = arguments[1];
    }
    return test(name, function() {
      return helpers.loginSuccessfully(url).then(f);
    });
  };

  helpers.setup = function(callback) {
    Ember.run(function() {
      App.__container__.lookup("auth:main").get("_session").clear();
      App.__container__.lookup("auth:main").trigger("signOutSuccess");
      return Em.Auth.Request.MyDummy.clearOptsList();
    });
    wait();
    if (callback) {
      callback();
    }
    App.reset();
    return wait();
  };

  module.exports = helpers;

}).call(this);

},{}]},{},[5])
;