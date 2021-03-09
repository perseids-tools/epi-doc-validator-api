RSpec.describe '/versions' do
  it 'returns a list of versions' do
    get '/versions/'

    expect(last_response).to be_ok
    expect(JSON.parse(last_response.body)).to eq([
      '8',
      '8-rc1',
      '8.2',
      '8.3',
      '8.4',
      '8.5',
      '8.6',
      '8.7',
      '8.8',
      '8.9',
      '8.10',
      '8.11',
      '8.12',
      '8.13',
      '8.14',
      '8.15',
      '8.16',
      '8.17',
      '8.18',
      '8.19',
      '8.20',
      '8.21',
      '8.22',
      '8.23',
      '9.0',
      '9.1',
      '9.2',
      'dev',
      'latest',
    ])
  end

  it 'does not require a trailing slash' do
    get '/versions'

    expect(last_response).to be_ok
  end
end
