<overlay>
  action: insert
  before: export default App
</overlay>

EmberAuth.registerOps({
  baseUrl: "http://localhost:5901",
  modules: ["emberData"]
});

if (false) {
  Ember.onLoad('Ember.Application', function(App) {
    App.initializer({
      name: "sign in models",

      initialize: function(container, application) {
        console.debug("in models init");
        return container.lookup("auth:main").on("signInSuccess", function() {
          console.debug("in success");
          return container.lookup("store:main").find('widget');
        });
      }
    });
  });
}

