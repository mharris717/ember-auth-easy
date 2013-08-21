res = {}

res.loadVendorLibs = function() {
  _ = require('./vendor/underscore');
  Handlebars = require("handlebars");
  require('./vendor/ember');
  require('./vendor/ember_data');
}

res.loadEmberAuth = function() {
  require ("ember-auth");
}

module.exports = res