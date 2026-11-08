class Referencia < ApplicationRecord
  belongs_to :concepto
  belongs_to :documento

  validates :concepto_id, uniqueness: { scope: :documento_id }
end
