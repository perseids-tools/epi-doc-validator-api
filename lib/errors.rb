def json_error(message)
  halt 422, { error: message }.to_json
end
