class Seccion < ApplicationRecord
  self.table_name = "secciones"

  CLAVES_PUBLICAS = %w[mision vision estrategia].freeze

  has_many :enlaces, dependent: :destroy

  validates :clave, presence: true, uniqueness: true
  validates :titulo, presence: true

  scope :publicas, -> { where(clave: CLAVES_PUBLICAS) }

  def self.por_clave(clave)
    find_by!(clave: clave)
  end

  def enlaces_ordenados
    enlaces.order(:orden, :titulo)
  end
end
