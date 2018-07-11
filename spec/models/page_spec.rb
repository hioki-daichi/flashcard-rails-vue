require 'rails_helper'

RSpec.describe Page, type: :model do
  describe 'validation' do
    it { is_expected.to belong_to(:book) }
    it { is_expected.to validate_presence_of(:question) }
    it { is_expected.to validate_presence_of(:answer) }
  end
end
