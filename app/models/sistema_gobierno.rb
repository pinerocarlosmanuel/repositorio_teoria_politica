class SistemaGobierno < ApplicationRecord
  include ConImagen

  has_many :enlace_sistema_gobiernos, dependent: :destroy
  has_one_attached :imagen

  ETAPAS = {
    "sociedad_primitiva" => "Sociedad primitiva",
    "esclavismo"         => "Esclavismo",
    "feudalismo"         => "Feudalismo",
    "absolutismo"        => "Absolutismo",
    "capitalismo"        => "Capitalismo y sus ramas",
    "socialismo"         => "Socialismo y sus variantes",
    "comunismo"          => "Comunismo",
    "no_materializados"  => "Sistemas no materializados o ideales",
    "otros_conceptos"    => "Otros conceptos de la ciencia política"
  }.freeze

  enum :estado, { borrador: 0, publicado: 1 }, default: :publicado

  validates :nombre, presence: true, uniqueness: true
  validates :etapa, inclusion: { in: ETAPAS.keys }

  scope :publicados, -> { where(estado: :publicado) }

  def self.ordenados_en_etapas
    publicados.sort_by { |s| [ ETAPAS.keys.index(s.etapa) || ETAPAS.size, s.orden || 0, s.nombre.to_s.downcase ] }
  end
end
