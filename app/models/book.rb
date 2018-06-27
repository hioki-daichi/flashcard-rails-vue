class Book < ApplicationRecord
  has_many :pages, dependent: :destroy

  validates :title, presence: true, uniqueness: true
end
