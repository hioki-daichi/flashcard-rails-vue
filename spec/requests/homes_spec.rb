require "rails_helper"

RSpec.describe Api::HomesController, type: :request do
  describe "GET /" do
    it "returns http status 200" do
      get "/"
      expect(response).to have_http_status 200
    end
  end

  describe "GET /nonexistent_path" do
    it "returns http status 302 and redirects to root" do
      get "/nonexistent_path"
      expect(response).to have_http_status 302
      expect(response.headers["Location"]).to eq "http://www.example.com/"
    end
  end
end
