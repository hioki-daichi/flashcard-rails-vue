require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation' do
    it { is_expected.to have_many(:books) }
  end
end
