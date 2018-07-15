require 'rails_helper'

RSpec.describe 'Basic specs', type: :request do
  describe 'JWT' do
    context 'when expired JWT is specified in Authorization header' do
      let(:headers) { { Authorization: "Bearer: #{JWT.encode({ user_id: 1, exp: Time.now.to_i }, JsonWebToken.key, JsonWebToken::ALG)}" } }

      it 'returns http status 419 and token expired error' do
        get '/api/books', headers: headers
        expect(response).to have_http_status 419
        expect(response.body).to eq "{\"errors\":[\"Token expired\"]}"
      end
    end

    context 'when invalid JWT is specified in Authorization header' do
      let(:headers) { { Authorization: "Bearer: invalid.jwt" } }

      it 'returns http status 400 and token invalid error' do
        get '/api/books', headers: headers
        expect(response).to have_http_status 400
        expect(response.body).to eq "{\"errors\":[\"Token invalid\"]}"
      end
    end
  end
end
