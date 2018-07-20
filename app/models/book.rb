class Book < ApplicationRecord
  include RankedModel
  ranks :row_order

  belongs_to :user

  has_many :pages, dependent: :destroy

  validates :title, presence: true, uniqueness: { scope: [:user_id] }, length: { maximum: 255 }
end
