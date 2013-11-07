<overlay>
  action: insert
  before: export default App
</overlay>

EmberAuth.registerOps({
  baseUrl: "http://localhost:5901",
  modules: ["emberData"]
});
