require 'rails_helper'

RSpec.describe PageArranger, type: :model do
  describe '.arrange!' do
    let!(:book) { create(:book) }

    context 'when passing the arguments in order of [2, 3, 1]' do
      let!(:page_1) { create(:page, book: book, row_order: 1) }
      let!(:page_2) { create(:page, book: book, row_order: 2) }
      let!(:page_3) { create(:page, book: book, row_order: 3) }

      let(:page_ids) { [page_2, page_3, page_1].map(&:id) }

      it 'arranges positions' do
        described_class.arrange!(book, page_ids)

        expect(page_2.reload.row_order).to be 0
        expect(page_3.reload.row_order).to be 1
        expect(page_1.reload.row_order).to be 2
      end
    end
  end
end
