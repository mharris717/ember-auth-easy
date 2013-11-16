require 'sinatra'
require 'json'

get "/" do
  "hello"
end

helpers do
  def set_origin
    response['Access-Control-Allow-Origin'] = '*'
    response['Access-Control-Allow-Headers'] = "Origin, X-Requested-With, Content-Type, Accept"
  end

  def users
    $users ||= [{id: 1, email: "user@fake.com", password: "password123"}]
  end

  def valid_creds?(email,password)
    res = users.any? do |u|
      u[:email] == email && u[:password] == password
    end
    puts "#{email} #{password} valid result: #{res} users #{users.size}"
    res
  end

  def request_params
    @request_params ||= JSON.parse(request.body.read)
  end

  def user_params
    request_params['user'] || {}
  end

  def add_user(email,password)
    puts "adding #{email} #{password}"
    users << {id: 2, email: email, password: password}
  end
end
 
before do
  set_origin
end

get "/widgets" do
  puts 'widgets zzzz'
  {widgets: [
    {id: 1, name: "Adam"},
    {id: 2, name: "Ben"}
  ]}.to_json
end

post "/users/sign_in.json" do
  puts user_params.inspect
  if valid_creds?(user_params['email'],user_params['password'])
    {}.to_json
  else
    halt 404
  end
end

get "/users.json" do
  {users: users}.to_json
end

options '/users/sign_in.json' do
  response.headers["Access-Control-Allow-Methods"] = "POST"

  halt 200
end

options '/users.json' do
  response.headers["Access-Control-Allow-Methods"] = "GET,POST"

  halt 200
end

post "/users.json" do
  puts "post users #{user_params.inspect}"
  add_user user_params['email'],user_params['password']
  {}.to_json
end