require 'sinatra'
require_relative 'data'

@all_turner = turner()
@all_geraete = geraete()

def filter_turner( )
  @all_turner
end

def filter_geraete()
  @all_geraete
end

def login
  karis()[@params[:kari].to_i]
end

get '/' do
  erb :login, :locals=>{:karis=>karis()}
end

post '/login' do

  erb :bewerten, :locals=>{:kari=>login() }
end