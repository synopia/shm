require 'sinatra'
require_relative 'data'



get '/' do
  erb :login, :locals=>{:karis=>karis()}
end