require 'rails_helper'

RSpec.describe JsonWebToken, type: :model do
  describe '.encode' do
    subject { JsonWebToken.encode(user_id: 1) }

    around { |e| travel_to('2020-07-24 23:59') { e.run } }

    it { is_expected.to eq 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJpYXQiOjE1OTU2MDI3NDAsImV4cCI6MTU5NTYxNzE0MH0.zYs-haIyt0kXJCQfiie56_3d9oA4fEL59DaSkfQt3U0' }
  end

  describe '.decode' do
    subject { JsonWebToken.decode('eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJpYXQiOjE1OTU2MDI3NDAsImV4cCI6MTU5NTYxNzE0MH0.zYs-haIyt0kXJCQfiie56_3d9oA4fEL59DaSkfQt3U0') }

    it { is_expected.to eq('user_id' => 1, 'iat' => 1595602740, 'exp' => 1595617140) }
  end
end
