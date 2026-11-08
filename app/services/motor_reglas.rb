class MotorReglas
  PRIORIDAD = %w[definicion_concepto documentos_tema sistema_pais recursos_tic
                 informacion_general agradecimiento].each_with_index.to_h.freeze

  NORMALIZA = lambda { |s|
    s.to_s.downcase
        .unicode_normalize(:nfkd).gsub(/\p{Mn}/, "")
        .strip
  }

  def self.responder(pregunta)
    texto = NORMALIZA.call(pregunta)
    regla = mejor_regla(texto)
    if regla
      { regla: regla, respuesta: respuesta_para(regla, texto), matched: true }
    else
      { regla: nil, respuesta: fallback(texto), matched: false }
    end
  end

  # Coincidencias por palabra completa (límites de palabra, sin subcadenas) > prioridad del intent
  def self.mejor_regla(texto)
    coincidencias = Regla.activas.map do |r|
      [r, r.keyword_list.count { |k| texto.match?(/\b#{Regexp.escape(NORMALIZA.call(k))}\b/) }]
    end
    coincidencias
      .select { |_, n| n > 0 }
      .max_by { |r, n| [n, -PRIORIDAD.fetch(r.intent, 99)] }
      &.first
  end

  def self.respuesta_para(regla, texto)
    case regla.intent
    when "definicion_concepto" then concepto_respuesta(texto)
    when "documentos_tema"     then documentos_respuesta(texto)
    when "sistema_pais"        then sistema_respuesta(texto)
    when "recursos_tic"        then recursos_respuesta(texto)
    when "informacion_general" then regla.respuesta
    else regla.respuesta
    end
  end

  def self.concepto_respuesta(texto)
    termino_limpio = texto.gsub(/(que es|que significa|definicion|de|el|la|los|las|un|una|para)\b/, "")
                          .gsub(/[¿?¡!.,:;()]/, "").strip
    termino_busqueda = NORMALIZA.call(termino_limpio)
    c = Concepto.publicados.find do |concepto|
      t = NORMALIZA.call(concepto.termino)
      termino_busqueda.present? && (t == termino_busqueda || t.include?(termino_busqueda))
    end
    return "No encontré «#{termino_limpio.presence || 'ese concepto'}» entre los conceptos publicados." unless c

    "«#{c.termino}» se define como: #{c.definicion} (Tema: #{c.tema.nombre}). Fuente: #{c.fuente.presence || 'No especificada'}."
  end

  def self.documentos_respuesta(texto)
    docs = Documento.publicados.busqueda(texto).limit(3)
    return "No encontré documentos relacionados con tu consulta." if docs.empty?

    "Documentos relacionados:\n" + docs.map { |d| "- #{d.titulo} (#{d.anio}), #{d.autores}" }.join("\n")
  end

  def self.sistema_respuesta(texto)
    pais = Pais.all.find { |p| texto.include?(NORMALIZA.call(p.nombre)) }
    return "Menciona un país registrado en la base de datos." unless pais

    tipos = { "politico" => "político", "electoral" => "electoral", "constitucional" => "constitucional" }
    tipo = tipos.keys.find { |t| texto.include?(t) } || "politico"
    sistema = pais.sistemas.find_by(tipo: tipo)
    return "«#{pais.nombre}» no tiene registrado el sistema #{tipos[tipo]}." unless sistema

    "Sistema #{tipos[tipo]} de #{pais.nombre}: #{sistema.descripcion} (Particularidades: #{sistema.particularidades.count})."
  end

  def self.recursos_respuesta(texto)
    recursos = RecursoDidactico.publicados.busqueda(texto).limit(3)
    return "No encontré recursos didácticos relacionados con tu consulta." if recursos.empty?

    "Recursos didácticos relacionados:\n" +
      recursos.map { |r| "- #{r.titulo} (#{RecursoDidactico.tipos.key(r.tipo)})" }.join("\n")
  end

  def self.fallback(texto)
    terminos = texto.split.map { |t| "%#{t}%" }
    conceptos = Concepto.publicados
                        .where("termino ILIKE ANY (ARRAY[?])", terminos)
                        .limit(3)
    return "No comprendí tu consulta. Intenta con: «¿Qué es el poder político?», «Documentos sobre Estado» o «Sistema electoral de Cuba»." if conceptos.empty?

    "No encontré una respuesta exacta, pero estos conceptos pueden ayudarte:\n" +
      conceptos.map { |c| "- #{c.termino}" }.join("\n")
  end
end
