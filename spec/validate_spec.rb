RSpec.describe '/validate' do
  let(:valid_doc) { fixture('valid_doc.xml') }
  let(:invalid_doc) { fixture('invalid_doc.xml') }
  let(:valid9) { fixture('valid_9.xml') }

  it 'returns an empty array when the EpiDoc XML is valid' do
    post '/validate/', valid_doc

    expect(last_response).to be_ok
    expect(JSON.parse(last_response.body)).to eq([])
  end

  it 'returns an array of errors when there are errors in the EpiDoc XML' do
    post '/validate/', invalid_doc

    expect(last_response).to be_ok
    expect(JSON.parse(last_response.body)).to eq([
      '-1:-1: ERROR: unknown element "incorrect" from namespace "http://www.tei-c.org/ns/1.0"',
    ])
  end

  it 'clears the errors before the next request' do
    post '/validate/', invalid_doc
    post '/validate/', valid_doc

    expect(last_response).to be_ok
    expect(JSON.parse(last_response.body)).to eq([])
  end

  it 'validates against a different EpiDoc version' do
    post '/validate/9.1/', valid9

    expect(last_response).to be_ok
    expect(JSON.parse(last_response.body)).to eq([])

    post '/validate/8.23/', valid9
    expect(JSON.parse(last_response.body)).to eq([
      '-1:-1: ERROR: attribute "toWhom" not allowed at this point; ignored',
    ])
  end

  it 'returns an error when the EpiDoc version is not supported' do
    post '/validate/nonexistent/', valid_doc

    expect(last_response).to be_unprocessable
    expect(JSON.parse(last_response.body)).to match(
      {
        'error' => /\AVersion nonexistent not supported. Supported versions: \["8",.*"latest"\]\z/,
      },
    )
  end

  it 'does not require a trailing slash' do
    post '/validate', valid_doc

    expect(last_response).to be_ok

    post '/validate/9.1', valid9

    expect(last_response).to be_ok
  end
end
