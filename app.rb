require 'sinatra'
require 'json'
require_relative 'my_user_model.rb'

set('views', './views')

set :port, 8080
set :bind, '0.0.0.0'
enable :sessions

get '/' do
    user = User.new()
    @users = user.all()
    erb :index
end

get '/users' do
 content_type:json
 User.all.to_json
end

post '/sign_in' do
    user_there = User.authentification(params[:password], params[:email])
    if !user_there.empty?
      status 200
      session[:user_id] = user_there[0]["id"]
      user_there[0].to_json
    else
      status 401
    end
  end


post '/users' do
 if params[:firstname] != nil
    user_welcome = User.create(params)
    user_new = User.find(user_welcome.id)
    user = {
      firstname: user_new.firstname,
      lastname: user_new.lastname,
      age: user_new.age,
      password: user_new.password,
      email: user_new.email
    }.to_json
 else
    see_if_user_here = User.authentification(params[:password], params[:email])
    if !see_if_user_here[0].empty?
      status 200
      session[:user_id] = see_if_user_here[0]["id"]
    else
      status 401
    end
    see_if_user_here[0].to_json
 end
end

put '/users' do
    User.update(session[:user_id], 'password', params[:password])
    user = User.find(session[:user_id])
    status 200
    user_info = {
    firstname: user.firstname,
    lastname: user.lastname,
    age: user.age,
    password: user.password,
    email: user.email
    }.to_json
  end
  
  

  delete '/users' do
    user_id = session[:user_id]
    halt 401, json({ message: 'Not authorized' }) if user_id.nil?
    User.new.destroy(user_id)
    session.clear
    status 204
  end