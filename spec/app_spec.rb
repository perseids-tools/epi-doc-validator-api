RSpec.describe '/validate' do
  let(:valid_doc) { fixture('valid_doc.xml') }
  let(:invalid_doc) { fixture('invalid_doc.xml') }
  let(:valid9) { fixture('valid_9.xml') }

  it 'returns an empty array when valid' do
    post '/validate/', { xml: valid_doc }.to_json, as: :json

    expect(last_response).to be_ok
    expect(JSON.parse(last_response.body)).to eq([])
  end

  it 'returns an array of errors when there are errors' do
    post '/validate/', { xml: invalid_doc }.to_json, as: :json

    expect(last_response).to be_ok
    expect(JSON.parse(last_response.body)).to eq([
      '-1:-1: ERROR: unknown element "incorrect" from namespace "http://www.tei-c.org/ns/1.0"',
    ])
  end

  it 'validates against a different EpiDoc version' do
    post '/validate/9.1', { xml: valid9 }.to_json, as: :json

    expect(last_response).to be_ok
    expect(JSON.parse(last_response.body)).to eq([])

    post '/validate/8.23', { xml: valid9 }.to_json, as: :json
    expect(JSON.parse(last_response.body)).to eq([
      '-1:-1: ERROR: attribute "toWhom" not allowed at this point; ignored',
    ])
  end

  it 'returns an error when the version is not supported' do
    post '/validate/nonexistent', { xml: valid_doc }.to_json, as: :json

    expect(last_response).to be_unprocessable
    expect(JSON.parse(last_response.body)).to match(
      {
        'error' => /\AVersion nonexistent not supported. Supported versions: \["8",.*"latest"\]\z/,
      },
    )
  end

  it 'returns an error when the JSON is valid but incorrect' do
    post '/validate/', { not: 'correct' }.to_json, as: :json

    expect(last_response).to be_unprocessable
    expect(JSON.parse(last_response.body)).to eq({ 'error' => 'Missing "xml" field from JSON' })
  end

  it 'returns an error when the JSON is invalid' do
    post '/validate/', 'string', as: :json

    expect(last_response).to be_unprocessable
    expect(JSON.parse(last_response.body)).to eq({ 'error' => 'Invalid JSON' })
  end

  it 'returns an error when no JSON is given' do
    post '/validate/'

    expect(last_response).to be_unprocessable
    expect(JSON.parse(last_response.body)).to eq({ 'error' => 'Invalid JSON' })
  end
end
