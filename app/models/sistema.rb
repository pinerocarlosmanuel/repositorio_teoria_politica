class Sistema < ApplicationRecord
  belongs_to :pais
  has_many :particularidades, dependent: :destroy

  enum :tipo, { politico: 0, electoral: 1, constitucional: 2 }

  validates :tipo, presence: true, uniqueness: { scope: :pais_id }
end
