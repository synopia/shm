require 'sinatra'
require 'data'



get '/hi' do
  data()[1].to_s
end