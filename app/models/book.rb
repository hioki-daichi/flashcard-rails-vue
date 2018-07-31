class Book < ApplicationRecord
  include RankedModel
  ranks :row_order

  include HasSub

  belongs_to :user

  has_many :pages, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }
end
