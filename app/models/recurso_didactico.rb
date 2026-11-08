class RecursoDidactico < ApplicationRecord
  include Adjuntable

  self.table_name = "recursos_didacticos"

  enum :tipo, { material: 0, actividad: 1, bibliografia: 2, enlace: 3 }, default: :material
  enum :estado, { borrador: 0, publicado: 1 }, default: :borrador

  has_one_attached :archivo

  validates :titulo, presence: true

  scope :publicados, -> { where(estado: :publicado) }

  include PgSearch::Model
  pg_search_scope :busqueda,
                  against: %i[titulo descripcion],
                  using: { tsearch: { prefix: true, any_word: true } }
end
