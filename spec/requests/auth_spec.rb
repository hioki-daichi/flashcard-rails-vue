require "rails_helper"

RSpec.describe "Auth", type: :request do
  subject(:body) { JSON.parse(response.body) }

  let!(:user) { create(:user, email: email, password: password) }
  let(:email) { "valid@example.com" }
  let(:password) { "valid" }

  describe "POST /api/auth" do
    let(:path) { "/api/auth" }

    shared_examples_for "unauthorized" do
      it "returns http status 401" do
        post path, params: params
        expect(response).to have_http_status 401
      end

      it "returns nothing" do
        post path, params: params
        expect(response.body).to eq ""
      end
    end

    context "when valid parameters passed" do
      let(:params) { { email: email, password: password } }

      it "returns http status 200" do
        post path, params: params
        expect(response).to have_http_status 200
      end

      it "returns token key" do
        post path, params: params
        expect(body.keys).to contain_exactly("token")
      end

      it "returns token string" do
        post path, params: params
        expect(body["token"]).to be_a String
      end
    end

    context "when invalid password passed" do
      let(:params) { { email: email, password: "invalid" } }
      it_behaves_like "unauthorized"
    end

    context "when invalid email and password passed" do
      let(:params) { { email: "invalid@example.com", password: "invalid" } }
      it_behaves_like "unauthorized"
    end

    context "when only email passed" do
      let(:params) { { email: email } }
      it_behaves_like "unauthorized"
    end

    context "when only password passed" do
      let(:params) { { password: password } }
      it_behaves_like "unauthorized"
    end
  end
end
