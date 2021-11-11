require 'sinatra'
require 'json'
require 'epi_doc_validator'

require './lib/config'
require './lib/errors'

set :strict_paths, false
set :port, Config::PORT
set :validator, EpiDocValidator::Validator.new

before { content_type :json }

post '/validate(/:version)?' do
  version = params[:version] || 'latest'

  if settings.validator.versions.member?(version)
    request.body.rewind

    settings.validator.errors(request.body.read, version: version).to_json
  else
    message = "Version #{version} not supported. " \
              "Supported versions: #{settings.validator.versions.inspect}"

    halt 422, { error: message }.to_json
  end
end

get '/versions' do
  settings.validator.versions.to_json
end
