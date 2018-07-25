require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validation' do
    subject { create(:book) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:pages) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(255) }
  end
end
