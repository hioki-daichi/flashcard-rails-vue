class Page < ApplicationRecord
  include RankedModel
  ranks :row_order

  belongs_to :book

  validates :path, length: { maximum: 255 }
  validates :question, presence: true, length: { maximum: 2048 }
  validates :answer, presence: true, length: { maximum: 2048 }
end
