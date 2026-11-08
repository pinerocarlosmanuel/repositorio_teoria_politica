class Tema < ApplicationRecord
  has_many :conceptos, dependent: :destroy

  validates :nombre, presence: true, uniqueness: true
end
