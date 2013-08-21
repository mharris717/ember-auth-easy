Em.TEMPLATES['_user_status'] = Em.Handlebars.compile('{{#if App.Auth.signedIn}}   Signed In as {{App.Auth.user.email}}   {{render sign_out}} {{else}}   {{render sign_in}} {{/if}}');

Em.TEMPLATES['sign_in'] = Em.Handlebars.compile('<form class="form-inline">   {{#if showLoginForm}}     {{view Em.TextField valueBinding="email" placeholder="Email"}}     {{view Em.TextField valueBinding="password" placeholder="Password"}}     <button {{action "login"}}>Login</button>   {{/if}}    <a {{bindAttr href="dropboxUrl"}}>Login with Dropbox</a> </form>');

Em.TEMPLATES['sign_out'] = Em.Handlebars.compile('<a href="#" {{action "logout"}}>Logout</a> {{#if App.Auth.user.providers.fatsecret}}    {{else}}   {{#if App.useFatSecret}}     <a {{bindAttr href="fatsecretUrl"}}>Connect FatSecret</a>   {{/if}} {{/if}}');

