require 'rails_helper'

RSpec.describe BookArranger, type: :model do
  describe '.arrange!' do
    let!(:user) { create(:user) }

    context 'when passing the arguments in order of [2, 3, 1]' do
      let!(:book_1) { create(:book, user: user, position: 1) }
      let!(:book_2) { create(:book, user: user, position: 2) }
      let!(:book_3) { create(:book, user: user, position: 3) }

      let(:book_ids) { [book_2, book_3, book_1].map(&:id) }

      it 'arranges positions' do
        described_class.arrange!(user, book_ids)

        expect(book_2.reload.position).to be 0
        expect(book_3.reload.position).to be 1
        expect(book_1.reload.position).to be 2
      end
    end
  end
end
