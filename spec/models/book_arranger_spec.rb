require 'rails_helper'

RSpec.describe BookArranger, type: :model do
  describe '.arrange!' do
    let!(:user) { create(:user) }

    context 'when passing the arguments in order of [2, 3, 1]' do
      let!(:book_1) { create(:book, user: user, row_order: 1) }
      let!(:book_2) { create(:book, user: user, row_order: 2) }
      let!(:book_3) { create(:book, user: user, row_order: 3) }

      let(:book_ids) { [book_2, book_3, book_1].map(&:id) }

      it 'arranges row_orders' do
        described_class.arrange!(user, book_ids)

        expect(book_2.reload.row_order).to be 0
        expect(book_3.reload.row_order).to be 1
        expect(book_1.reload.row_order).to be 2
      end
    end
  end
end
