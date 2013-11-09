Em.Auth.Request.MyDummy = Em.Object.extend
  validCreds: (email,password,opts) ->
    console.debug "email: #{email} password: #{password}"
    opts.store.find('user').then (users) ->
      console.debug "users size #{users.length} #{users.get('length')}"
      found = null
      users.forEach (user) ->
        console.debug "in loop email: #{user.get('email')} password: #{user.get('password')}"
        if user.get('email') == email && user.get('password') == password
          found = user

      if found
        opts.success(found)
      else
        opts.failure()




  signIn: (url, opts = {}) ->
    console.mylog "sign in opts"
    console.mylog opts

    #@send(opts)

    @validCreds opts.data.user.email,opts.data.user.password, 
      store: opts.store
      success: (user) =>
        console.debug "is valid"
        @auth.trigger 'signInSuccess'
        @auth.set 'user', user
        @auth.trigger 'signInComplete'
      failure: =>
        console.debug "is not valid"
        @auth.trigger 'signInError'
        @auth.trigger 'signInComplete'


  signInx: ->
    @auth.trigger 'signInError' 

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