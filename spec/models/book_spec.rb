require "rails_helper"

RSpec.describe Book, type: :model do
  describe "validation" do
    subject { create(:book) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:pages) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(255) }
  end

  describe "before_create" do
    describe "#set_sub" do
      it "sets non-overlapping sub" do
        existing_sub = create(:book).sub
        not_existing_sub = "1234567"

        book = build(:book)
        expect(book).to receive(:generate_sub).and_return(existing_sub, not_existing_sub)
        book.save
        expect(book.sub).to eq not_existing_sub
      end
    end
  end
end
