module ApplicationHelper
  # Patrón labpro_front: lee valores por clave ('front', 'main', 'menu', 'portada').
  def front_config(campo, clave = "front")
    @front_config_cache ||= {}
    @front_config_cache[clave] ||= Configuracion.valores(clave)
    @front_config_cache[clave][campo.to_sym]
  end

  def menu_items
    @menu_items ||= Configuracion.items_menu
  end

  def enlaces_de_interes
    [
      [ front_config(:interes1), front_config(:interes1_url) ],
      [ front_config(:interes2), front_config(:interes2_url) ],
      [ front_config(:interes3), front_config(:interes3_url) ]
    ].reject { |etiqueta, url| etiqueta.blank? || url.blank? }
  end

  def item_titulo(item)
    case item
    when Concepto then item.termino
    when Documento then item.titulo
    when Pais then item.nombre
    when RecursoDidactico then item.titulo
    end
  end

  def item_resumen(item)
    case item
    when Concepto then item.definicion
    when Documento then item.resumen.to_s
    when Pais then item.descripcion.to_s
    when RecursoDidactico then item.descripcion.to_s
    end
  end

  # Facetas estilo REPXOS ("Descubrir por:")
  def filtros_activos
    { q: params[:q], autor: params[:autor], decada: params[:decada], tipo: params[:tipo], tema: params[:tema] }.compact
  end

  def formato_adjunto(adjunto)
    File.extname(adjunto.filename.to_s).delete(".").upcase.presence || "ARCHIVO"
  end

  def etiqueta_adjunto(adjunto)
    "#{adjunto.filename} · #{number_to_human_size(adjunto.byte_size)}"
  end

  def puede_descargar?(record)
    record.publicado? || current_user&.admin? || current_user&.editor?
  end

  # ---- Gráficos CSS (sin dependencias externas) ----
  PALETA = %w[#0d6efd #6610f2 #dc3545 #198754 #fd7e14 #0dcaf0 #6f42c1 #ffc107].freeze

  def gradiente_donut(datos)
    total = datos.values.sum.to_f
    return "" if total.zero?

    acum = 0
    paradas = datos.values.each_with_index.map do |v, i|
      inicio = (acum / total) * 100
      acum += v
      fin = (acum / total) * 100
      "#{PALETA[i % PALETA.size]} #{inicio.round(2)}% #{fin.round(2)}%"
    end
    "conic-gradient(#{paradas.join(", ")})"
  end

  def ancho_porcentaje(valor, maximo)
    maximo.to_f.zero? ? 0 : (valor.to_f / maximo) * 100
  end

  def color_paleta(indice)
    PALETA[indice % PALETA.size]
  end

  def facetas_autores(limite = 10)
    Documento.publicados.pluck(:autores)
             .flat_map { |a| a.to_s.split(";").map(&:strip).reject(&:blank?) }
             .tally.sort_by { |_nombre, n| -n }.first(limite)
  end

  def facetas_tematicas(limite = 10)
    Concepto.publicados.joins(:tema).group("temas.nombre").count
            .sort_by { |_tema, n| -n }.first(limite)
  end

  def facetas_fechas(limite = 6)
    Documento.publicados.pluck(:anio).compact
             .group_by { |a| a / 10 * 10 }
             .map { |d, años| [ "#{d} - #{d + 9}", años.size ] }
             .sort_by { |_rango, n| -n }.first(limite)
  end
end
