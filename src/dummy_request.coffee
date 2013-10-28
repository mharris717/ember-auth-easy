Em.Auth.Request.MyDummy = Em.Object.extend
  validCreds: (email,password) ->
    if email == "user@fake.com" && password == 'password123'
      true
    else
      false

  signIn: (url, opts = {}) ->
    console.mylog "sign in opts"
    console.mylog opts

    @send(opts)

    if @validCreds(opts.data.email,opts.data.password)
      @auth.trigger 'signInSuccess'
      @auth.set 'user', opts.store.createRecord(App.User, {email: opts.data.email, id: 1, auth_token: "token123"})
    else
      @auth.trigger 'signInError'
    @auth.trigger 'signInComplete'
    {email: opts.data.email, id: 1, auth_token: "token123"}

  signOut: (url, opts = {}) ->
    @send opts
    switch opts.status
      when 'success' then @auth.trigger 'signOutSuccess'
      when 'error'   then @auth.trigger 'signOutError'
    @auth.trigger 'signOutComplete'

  send: (opts = {}) ->
    console.mylog "MyDummy send"
    console.mylog opts
    Em.Auth.Request.MyDummy.addSendOpts(opts)
    
    res = {}
    for k,v of opts
      res[k] = v
    res
    if opts && opts.data && @validCreds(opts.data.email,opts.data.password)
      res.auth_token = "token123"

    if opts && opts.url && opts.url.match("/posts")
      a = []
      a.push(id: 1, title: "Fun")
      a.push(id: 2, title: "More Fun")

      res = {posts: a}
      console.mylog res
      res
    else
      @auth._response.canonicalize res

Em.Auth.Request.MyDummy.reopenClass
  addSendOpts: (ops) ->
    @getOptsList().push(ops)
  getOptsList: ->
    @optsList ||= []
    @optsList
  clearOptsList: ->
    @optsList = []