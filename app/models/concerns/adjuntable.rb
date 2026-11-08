module Adjuntable
  extend ActiveSupport::Concern

  TIPOS_PERMITIDOS = %w[
    application/pdf
    application/msword
    application/vnd.openxmlformats-officedocument.wordprocessingml.document
    application/epub+zip
    text/plain
    application/vnd.ms-powerpoint
    application/vnd.openxmlformats-officedocument.presentationml.presentation
  ].freeze

  MAXIMO_MB = 50

  included do
    validate :validar_archivo_adjunto
  end

  private

  def validar_archivo_adjunto
    return unless archivo.attached?

    if archivo.blob.content_type.present? && !TIPOS_PERMITIDOS.include?(archivo.blob.content_type)
      errors.add(:archivo, "debe ser PDF, DOC, DOCX, EPUB, TXT, PPT o PPTX")
    end
    if archivo.blob.byte_size > MAXIMO_MB.megabytes
      errors.add(:archivo, "no puede superar los #{MAXIMO_MB} MB")
    end
  end
end
