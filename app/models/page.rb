class Page < ApplicationRecord
  belongs_to :book

  validates :path, length: { maximum: 255 }
  validates :question, presence: true, length: { maximum: 1000 }
  validates :answer, presence: true, length: { maximum: 1000 }
end
