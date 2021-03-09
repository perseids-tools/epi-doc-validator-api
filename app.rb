require 'sinatra'
require 'json'
require 'epi_doc_validator'

require './lib/config'
require './lib/errors'

set :port, Config::PORT
set :validator, EpiDocValidator::Validator.new

before { content_type :json }

error JSON::ParserError do
  json_error('Invalid JSON')
end

post '/validate/:version?' do
  version = params[:version] || 'latest'

  if settings.validator.versions.member?(version)
    request.body.rewind
    data = JSON.parse(request.body.read)

    if data['xml']
      settings.validator.errors(data['xml'], version: version).to_json
    else
      json_error('Missing "xml" field from JSON')
    end
  else
    json_error(
      "Version #{version} not supported. " \
      "Supported versions: #{settings.validator.versions.inspect}",
    )
  end
end
