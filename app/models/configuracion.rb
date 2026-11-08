class Configuracion < ApplicationRecord
  self.table_name = "configuraciones"

  # Patrón del plugin labpro_front/labpro_settings: un ajuste por clave
  # con su valor como Hash (serialize :value). Cada clave es un singleton.
  CLAVES = %w[front main menu portada].freeze
  CLAVE_FRONT = "front"
  CLAVE_MAIN = "main"
  CLAVE_MENU = "menu"
  CLAVE_PORTADA = "portada"

  VALORES_DEFECTO = {
    "front" => {
      "empresa"        => "Repositorio Teoría Política",
      "organismo"      => "Ministerio de Educación Superior (MES)",
      "proyecto"       => "Proyecto NA223LH508-012",
      "slogan"         => "Conceptos, documentación científica, sistemas políticos comparados y recursos didácticos",
      "tagline"        => "Fondo consultable de Teoría Política · TIC, TEP, TAC e Inteligencia Artificial",
      "footer"         => "Repositorio Teoría Política · Ministerio de Educación Superior (MES) · Proyecto NA223LH508-012",
      "email"          => "contacto@teoriapolitica.cu",
      "telefono"       => "+53 7800 0000",
      "direccion"      => "La Habana, Cuba",
      "facebook"       => "https://facebook.com/",
      "twitter"        => "https://twitter.com/",
      "youtube"        => "https://youtube.com/",
      "instagram"      => "https://instagram.com/",
      "interes1"       => "Sitio institucional MES",
      "interes1_url"   => "https://www.mes.gob.cu",
      "interes2"       => "Spanish Revolutions",
      "interes2_url"   => "https://spanishrevolutions.com",
      "interes3"       => "Archivo CIA (CREST)",
      "interes3_url"   => "https://www.cia.gov/readingroom/",
      "logo"           => ""
    },
    "main" => {
      "logo"             => "",
      "bg_image"         => "",
      "bg_phone_image"   => "",
      "footer_bg_image"  => "",
      "carousel"         => "0",
      "row"              => "1",
      "blocks_count"     => "5",
      "main_color"       => "#1f4e79",
      "objects_background" => "#163a5c",
      "script"           => ""
    },
    "menu" => {
      "menu_logo" => "",
      "items" => [
        { "label" => "Acerca de nosotros", "url" => "/acerca" },
        { "label" => "Conceptos", "url" => "/conceptos" },
        { "label" => "Documentos", "url" => "/documentos" },
        { "label" => "Sistemas", "url" => "/sistemas" },
        { "label" => "Cuba", "url" => "/cuba" },
        { "label" => "Comparativa", "url" => "/comparativa" },
        { "label" => "Recursos", "url" => "/recursos_didacticos" },
        { "label" => "Análisis", "url" => "/analisis" },
        { "label" => "Chatbot", "url" => "/chat" },
        { "label" => "Teoría de la conspiración", "url" => "/teoria_de_la_conspiracion" },
        { "label" => "Administración", "url" => "/administracion" },
        { "label" => "Nuevo concepto", "url" => "/conceptos/new" }
      ]
    },
    "portada" => {
      "titulo"           => "Bienvenido al Repositorio Teoría Política",
      "subtitulo"        => "Ministerio de Educación Superior (MES) · Proyecto NA223LH508-012",
      "descripcion"      => "Repositorio consultable de conceptos y categorías clave de la Teoría Política, " \
                            "documentación del proyecto, sistemas políticos (cubano y de países tipo) y recursos " \
                            "didácticos sobre TIC, TEP, TAC e Inteligencia Artificial.",
      "cta_label"        => "Explorar conceptos",
      "cta_url"          => "/conceptos",
      "mostrar_carrusel" => "1",
      "imagen_fondo"     => ""
    }
  }.freeze

  validates :clave, presence: true, uniqueness: true

  # Alias de compatibilidad: clave única 'front'
  def self.front
    reg(CLAVE_FRONT)
  end

  def self.valores_front
    valores(CLAVE_FRONT)
  end

  # Devuelve el registro (creado en memoria si falta) para una clave.
  def self.reg(clave)
    find_or_initialize_by(clave: clave)
  end

  # Valores efectivos de una clave: defectos + lo persistido (Hash).
  def self.valores(clave)
    base = VALORES_DEFECTO.fetch(clave, {})
    registro = reg(clave)
    return base.deep_symbolize_keys unless registro.persisted?

    valor = registro.valor
    merge = valor.is_a?(Hash) ? valor : {}
    base.merge(merge).deep_symbolize_keys
  end

  # Lista de elementos del menú (etiqueta + url) derivada de la configuración.
  def self.items_menu
    items = valores(CLAVE_MENU)[:items]
    items = items.is_a?(Array) ? items : []
    normalizados = items.filter_map do |item|
      if item.respond_to?(:with_indifferent_access)
        item = item.with_indifferent_access
        label = item[:label].to_s.strip
        label = item["label"].to_s.strip if label.empty?
      else
        label = (item[:label] || item["label"]).to_s.strip
      end
      next if label.blank?

      { label: label, url: (item[:url] || item["url"]).to_s }
    end
    normalizados.presence || VALORES_DEFECTO.fetch("menu")["items"].map { |i| { label: i["label"], url: i["url"] } }
  end
end
