class Variable < ApplicationRecord
  belongs_to :particularidad
  has_many :indicadores, dependent: :destroy

  validates :nombre, presence: true
end
