class Documento < ApplicationRecord
  include Adjuntable

  has_many :referencias, dependent: :destroy
  has_many :conceptos, through: :referencias
  has_one_attached :archivo

  enum :tipo, { articulo: 0, tesis: 1, libro: 2, informe: 3, otro: 4 }, default: :articulo
  enum :estado, { borrador: 0, publicado: 1 }, default: :borrador

  validates :titulo, presence: true

  scope :publicados, -> { where(estado: :publicado) }

  def archivo_url
    return nil unless archivo.attached?

    Rails.application.routes.url_helpers.rails_blob_path(archivo, only_path: true)
  end

  include PgSearch::Model
  pg_search_scope :busqueda,
                  against: %i[titulo resumen referencia],
                  using: { tsearch: { prefix: true, any_word: true } }
end
