class EnlaceSistemaGobierno < ApplicationRecord
  belongs_to :sistema_gobierno

  validates :titulo, presence: true
  validates :url, presence: true, format: { with: %r{\Ahttps?://}i, message: "debe comenzar por http:// o https://" }

  scope :ordenados, -> { order(:orden, :id) }
end
