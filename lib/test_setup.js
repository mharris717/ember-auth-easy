module.exports = {
  setup: function() {
    var jsdom = require('jsdom').jsdom;
    window = jsdom().createWindow();
    $ = jQuery = require('jquery').create(window)
  }
}