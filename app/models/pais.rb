class Pais < ApplicationRecord
  has_many :sistemas, dependent: :destroy

  enum :continente, { america: 0, europa: 1, africa: 2, asia: 3, oceania: 4 }, default: :america

  validates :nombre, presence: true, uniqueness: true

  scope :destacados, -> { where(destacado: true) }

  def sistemas_resumen
    sistemas.pluck(:tipo, :descripcion)
  end
end
