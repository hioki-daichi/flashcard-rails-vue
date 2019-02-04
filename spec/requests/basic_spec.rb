require 'rails_helper'

RSpec.describe 'Basic specs', type: :request do
  describe 'JWT' do
    context 'when expired JWT is specified in Authorization header' do
      let(:headers) { { Authorization: "Bearer: #{JWT.encode({ user_id: 1, exp: Time.now.to_i }, JsonWebToken.key, JsonWebToken::ALG)}" } }

      it 'returns http status 419 and token expired error' do
        post '/graphql', params: { 'query': '{ books { sub } }' }, headers: headers
        expect(response).to have_http_status 419
        expect(response.body).to eq "{\"errors\":[\"Token expired\"]}"
      end
    end

    context 'when invalid JWT is specified in Authorization header' do
      let(:headers) { { Authorization: "Bearer: invalid.jwt" } }

      it 'returns http status 400 and token invalid error' do
        post '/graphql', params: { 'query': '{ books { sub } }' }, headers: headers
        expect(response).to have_http_status 400
        expect(response.body).to eq "{\"errors\":[\"Token invalid\"]}"
      end
    end
  end

  describe 'Routing error' do
    shared_examples_for 'routing error' do
      it 'returns http status 404 and routing error' do
        subject
        expect(response).to have_http_status 404
        expect(response.body).to eq "{\"errors\":[\"No such route.\"]}"
      end
    end

    context 'when GET /api/' do
      subject { get '/api/' }
      it_behaves_like 'routing error'
    end

    context 'when POST /api/' do
      subject { post '/api/' }
      it_behaves_like 'routing error'
    end

    context 'when PATCH /api/' do
      subject { patch '/api/' }
      it_behaves_like 'routing error'
    end

    context 'when DELETE /api/' do
      subject { delete '/api/' }
      it_behaves_like 'routing error'
    end

    context 'when GET /api/foo' do
      subject { get '/api/foo' }
      it_behaves_like 'routing error'
    end

    context 'when POST /api/foo' do
      subject { post '/api/foo' }
      it_behaves_like 'routing error'
    end

    context 'when PATCH /api/foo' do
      subject { patch '/api/foo' }
      it_behaves_like 'routing error'
    end

    context 'when DELETE /api/foo' do
      subject { delete '/api/foo' }
      it_behaves_like 'routing error'
    end
  end
end
