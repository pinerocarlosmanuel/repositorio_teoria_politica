class Concepto < ApplicationRecord
  include Adjuntable

  belongs_to :tema
  has_many :referencias, dependent: :destroy
  has_many :documentos, through: :referencias
  has_many :enlace_conceptos, dependent: :destroy
  has_one_attached :archivo

  enum :estado, { borrador: 0, publicado: 1 }, default: :borrador

  validates :termino, presence: true, uniqueness: true
  validates :definicion, presence: true

  scope :publicados, -> { where(estado: :publicado) }
  scope :por_termino, ->(t) { where("termino ILIKE ?", "%#{t}%") }

  include PgSearch::Model
  pg_search_scope :busqueda,
                  against: %i[termino definicion sinonimos],
                  using: { tsearch: { prefix: true, any_word: true } }
end
