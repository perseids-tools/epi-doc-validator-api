require 'sinatra'
require './lib/config'

set :port, Config::PORT

before { content_type :json }

get '/' do
  { hello: 'world' }.to_json
end
