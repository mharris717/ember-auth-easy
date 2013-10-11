var helpers = {};

helpers.loginWith = function(email,password,url) {
  if (!url) url = "/";
  return visit(url)
  .fillIn(".login-form .email-field input",email)
  .fillIn(".login-form .password-field input",password)
  .click(".login-form button");
}

helpers.loginSuccessfully = function(url) {
  return helpers.loginWith("user@fake.com","password123",url);
}

helpers.loginFail = function() {
  return helpers.loginWith("user@fake.com","passwordwrong");
}

helpers.register = function(email,password) {
  return visit("/register")
  .fillIn(".register-form .email-field input",email)
  .fillIn(".register-form .password-field input",password)
  .click(".register-form button");
}

helpers.loggedInTest = function(name,f) {
  return test(name, function() {
    return EmberAuth.testHelpers.loginSuccessfully().then(f);
  })
};

module.exports = helpers;