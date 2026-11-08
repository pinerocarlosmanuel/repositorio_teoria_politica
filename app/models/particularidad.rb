class Particularidad < ApplicationRecord
  belongs_to :sistema
  has_many :variables, dependent: :destroy

  validates :titulo, presence: true
end
