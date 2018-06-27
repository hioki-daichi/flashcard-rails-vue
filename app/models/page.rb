class Page < ApplicationRecord
  belongs_to :book

  validates :question, presence: true
  validates :answer, presence: true
end
