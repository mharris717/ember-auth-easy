if (typeof(window) == "undefined") {
  var jsdom = require('jsdom').jsdom;
  window = jsdom().createWindow();
  $ = jQuery = require('jquery').create(window)
}

_ = require('./vendor/underscore');
Handlebars = require("handlebars");
require('./vendor/ember');
require('./vendor/ember_data');
require ("ember-auth");