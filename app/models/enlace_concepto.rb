class EnlaceConcepto < ApplicationRecord
  belongs_to :concepto

  validates :titulo, presence: true
  validates :url, presence: true, format: { with: %r{\Ahttps?://}i, message: "debe comenzar por http:// o https://" }

  scope :ordenados, -> { order(:orden, :id) }
end
