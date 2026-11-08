class Indicador < ApplicationRecord
  belongs_to :variable

  validates :nombre, presence: true
end
