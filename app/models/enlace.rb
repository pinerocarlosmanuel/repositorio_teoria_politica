class Enlace < ApplicationRecord
  belongs_to :seccion

  validates :titulo, presence: true
  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "debe ser una URL válida (http/https)" }
end
