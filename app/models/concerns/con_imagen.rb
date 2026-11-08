module ConImagen
  extend ActiveSupport::Concern

  IMAGENES_PERMITIDAS = %w[
    image/png
    image/jpeg
    image/svg+xml
  ].freeze

  MAXIMO_MB = 5

  included do
    validate :validar_imagen_adjunta
  end

  private

  def validar_imagen_adjunta
    return unless imagen.attached?

    if imagen.blob.content_type.present? && !IMAGENES_PERMITIDAS.include?(imagen.blob.content_type)
      errors.add(:imagen, "debe ser PNG, JPEG o SVG")
    end
    if imagen.blob.byte_size > MAXIMO_MB.megabytes
      errors.add(:imagen, "no puede superar los #{MAXIMO_MB} MB")
    end
  end
end