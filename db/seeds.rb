# Usuarios de demostración
admin = User.find_or_create_by!(email: "admin@proyecto.cu") do |u|
  u.nombre = "Administrador UCI"
  u.rol = :admin
  u.password = "Cambiar123!"
end
editor = User.find_or_create_by!(email: "editor@proyecto.cu") do |u|
  u.nombre = "Editor Proyecto"
  u.rol = :editor
  u.password = "Cambiar123!"
end

# M1 - Temas
temas = {}
[
  [ "Teoría del Estado", "Estudio del Estado, su naturaleza, formas y funciones." ],
  [ "Poder político", "Concepto y ejercicio del poder en la sociedad política." ],
  [ "Sistemas electorales", "Mecanismos de representación y elección." ],
  [ "Sistemas constitucionales", "Organización jurídica del poder." ],
  [ "Democracia", "Formas y teorías de la democracia." ]
].each do |nombre, descripcion|
  temas[nombre] = Tema.find_or_create_by!(nombre: nombre) { |t| t.descripcion = descripcion }
end

# M1 - Conceptos publicados
conceptos = {}
[
  [ "Poder político", "Capacidad de un actor social de imponer sus decisiones y de lograr la obediencia de otros en el marco de la sociedad política.", "autoridad; dominación; poder", "Política", "Teoría del Estado", "Bobbio, N. (1989). Teoría general de la política." ],
  [ "Estado", "Organización política soberana que ejerce el poder sobre una población y un territorio determinados.", "Estado nación; Estado de derecho", "Política", "Teoría del Estado", "Bobbio, N. (1989). Teoría general de la política." ],
  [ "Soberanía", "Atributo del poder estatal que no reconoce un poder superior dentro del territorio.", "autonomía; independencia", "Política", "Teoría del Estado", "Bodin, J. (1576). Los seis libros de la República." ],
  [ "Democracia", "Forma de gobierno en la que el poder político reside en el pueblo y se ejerce mediante la participación y la representación.", "gobierno del pueblo", "Política", "Democracia", "Sartori, G. (1987). Teoría de la democracia." ],
  [ "Hegemonía", "Dirección política, ideológica y cultural de una clase o bloque social sobre el conjunto de la sociedad.", "dominación ideológica", "Política", "Poder político", "Gramsci, A. (1929). Cuadernos de la cárcel." ],
  [ "Sistema electoral", "Conjunto de normas y procedimientos que regulan la conversión de votos en representación.", "mecanismo electoral", "Política", "Sistemas electorales", "Nohlen, D. (2004). Sistemas electorales en América Latina." ],
  [ "Constitución", "Norma suprema que organiza el Estado, reconoce derechos y establece los límites del poder.", "ley fundamental; carta magna", "Derecho", "Sistemas constitucionales", "Kelsen, H. (1934). Teoría pura del derecho." ],
  [ "Partido político", "Organización de ciudadanos que busca influir en el poder político y alcanzar la representación.", "agrupación política", "Política", "Poder político", "Duverger, M. (1951). Los partidos políticos." ],
  [ "Participación ciudadana", "Involucramiento de los ciudadanos en los asuntos públicos mediante mecanismos directos o representativos.", "participación política", "Política", "Democracia", "Santana, F. (2019). Participación en el sistema político cubano." ],
  [ "Opinión pública", "Conjunto de opiniones de la población sobre asuntos de interés general.", "opinión colectiva", "Comunicación", "Poder político", "Bourdieu, P. (1972). La opinión pública no existe." ]
].each do |termino, definicion, sinonimos, categoria, tema, fuente|
  conceptos[termino] = Concepto.find_or_create_by!(termino: termino) do |c|
    c.definicion = definicion
    c.sinonimos = sinonimos
    c.categoria = categoria
    c.tema = temas[tema]
    c.fuente = fuente
    c.estado = :publicado
  end
end

# M2 - Documentos (productos reales de la actividad 7.1.2)
documentos = {}
[
  [ "Ciberseguridad social desde la tradición CTS: una propuesta de intervención educativa para Cuba",
   "Álvarez Tur, J. M.; Piñeiro Ramírez, C. M.", 2026, :articulo,
   "Artículo previsto para publicación en la Revista Luz (DOAJ, ESCI, REDIB, SCIELO).",
   "Álvarez Tur, J. M. y Piñeiro Ramírez, C. M. (2026). Ciberseguridad social desde la tradición CTS: una propuesta de intervención educativa para Cuba. Revista Luz." ],
  [ "Desafíos políticos y económicos en la calidad de software cubano: una propuesta de optimización",
   "Piñeiro Ramírez, C. M.; Álvarez Tur, J. M.", 2026, :articulo,
   "Artículo publicado en la Revista EJES de economía y sociedad, Vol. 10, N.º 18.",
   "Piñeiro Ramírez, C. M. y Álvarez Tur, J. M. (2026). Desafíos políticos y económicos en la calidad de software cubano: una propuesta de optimización. Revista EJES, 10(18).", "https://doi.org/10.33255/25914669/7266" ],
  [ "La cibersubversión política estadounidense contra Cuba desde un enfoque tecnocientífico",
   "Álvarez Tur, J. M.", 2026, :tesis,
   "Tesis doctoral con concepción teórico-metodológica para contrarrestar la cibersubversión política estadounidense contra Cuba.",
   "Álvarez Tur, J. M. (2026). La cibersubversión política estadounidense contra Cuba desde un enfoque tecnocientífico. Tesis doctoral. UCI." ],
  [ "Teoría general de la política",
   "Bobbio, N.", 1989, :libro,
   "Obra clásica de referencia para los conceptos fundamentales de la Teoría Política.",
   "Bobbio, N. (1989). Teoría general de la política. Madrid: Taurus." ]
].each do |titulo, autores, anio, tipo, resumen, referencia, doi = nil|
  documentos[titulo] = Documento.find_or_create_by!(titulo: titulo) do |d|
    d.autores = autores
    d.anio = anio
    d.tipo = tipo
    d.resumen = resumen
    d.referencia = referencia
    d.doi = doi
    d.estado = :publicado
  end
end

# Vínculos concepto-documento (referencias)
[ [ "Poder político", "Teoría general de la política" ],
 [ "Estado", "Teoría general de la política" ],
 [ "Soberanía", "Teoría general de la política" ],
 [ "Participación ciudadana", "Ciberseguridad social desde la tradición CTS: una propuesta de intervención educativa para Cuba" ] ].each do |termino, titulo|
  concepto = conceptos[termino]
  documento = documentos[titulo]
  Referencia.find_or_create_by!(concepto: concepto, documento: documento)
end

# M3 - Países y sistemas
def sistema!(pais, tipo, descripcion)
  Sistema.find_or_create_by!(pais: pais, tipo: tipo) { |s| s.descripcion = descripcion }
end

cuba = Pais.find_or_create_by!(nombre: "Cuba") do |p|
  p.continente = :america
  p.region = "Caribe"
  p.destacado = true
  p.descripcion = "República de Cuba: Estado socialista de derecho y justicia social, según la Constitución de 2019."
end

s_politico = sistema!(cuba, :politico,
  "Estado socialista de derecho y justicia social, con el Partido Comunista de Cuba como fuerza política dirigente superior de la sociedad y del Estado (Constitución de 2019).")
s_electoral = sistema!(cuba, :electoral,
  "Sistema electoral con voto libre, igual, directo y secreto; elecciones periódicas de delegados, diputados y gobernadores, con candidatos propuestos por las organizaciones de masas.")
s_constitucional = sistema!(cuba, :constitucional,
  "Constitución de 2019: soberanía popular, estructura del Estado (Asamblea Nacional del Poder Popular, Consejo de Estado, Presidenta/e de la República), derechos y garantías.")

# Particularidades → Variables → Indicadores (Cuba - sistema político)
p1 = Particularidad.find_or_create_by!(sistema: s_politico, titulo: "Organización del poder estatal") do |p|
  p.descripcion = "Estructura de los órganos del poder popular y su relación."
end
v1 = Variable.find_or_create_by!(particularidad: p1, nombre: "Asamblea Nacional del Poder Popular") do |v|
  v.descripcion = "Órgano supremo del poder del Estado."
end
Indicador.find_or_create_by!(variable: v1, nombre: "Estructura y composición") do |i|
  i.descripcion = "Número de diputados y distribución por circunscripción."
  i.metodo = "Revisión documental de la convocatoria electoral."
end
Indicador.find_or_create_by!(variable: v1, nombre: "Período de mandato") do |i|
  i.descripcion = "Duración del mandato de los diputados."
  i.metodo = "Revisión de la Ley Electoral."
end

p2 = Particularidad.find_or_create_by!(sistema: s_politico, titulo: "Roles del Partido y las organizaciones de masas") do |p|
  p.descripcion = "Participación de las organizaciones en la vida política."
end
v2 = Variable.find_or_create_by!(particularidad: p2, nombre: "Participación de las organizaciones de masas") do |v|
  v.descripcion = "Mecanismos de postulación de candidatos."
end
Indicador.find_or_create_by!(variable: v2, nombre: "Postulación de candidatos") do |i|
  i.descripcion = "Proceso de propuesta y ratificación de candidatos."
  i.metodo = "Observación del proceso de postulación y análisis de documentos."
end

p3 = Particularidad.find_or_create_by!(sistema: s_politico, titulo: "Presidencia de la República y Consejo de Estado") do |p|
  p.descripcion = "Jefatura del Estado y órgano colegiado que la asiste."
end
v3 = Variable.find_or_create_by!(particularidad: p3, nombre: "Presidenta/e de la República") do |v|
  v.descripcion = "Jefatura del Estado, jefatura del Gobierno y jefatura del Consejo de Defensa Nacional."
end
Indicador.find_or_create_by!(variable: v3, nombre: "Período de mandato") do |i|
  i.descripcion = "Duración de 5 años, renovable."
  i.metodo = "Revisión del artículo 128 de la Constitución de 2019."
end
Indicador.find_or_create_by!(variable: v3, nombre: "Forma de elección") do |i|
  i.descripcion = "Elección por la Asamblea Nacional del Poder Popular entre sus diputados."
  i.metodo = "Revisión del artículo 126 de la Constitución de 2019."
end

p4 = Particularidad.find_or_create_by!(sistema: s_electoral, titulo: "Elecciones del Poder Popular") do |p|
  p.descripcion = "Elecciones periódicas de delegados, gobernadores y diputados."
end
v4 = Variable.find_or_create_by!(particularidad: p4, nombre: "Elecciones de delegados municipales") do |v|
  v.descripcion = "Renovación de la base del Poder Popular."
end
Indicador.find_or_create_by!(variable: v4, nombre: "Periodicidad") do |i|
  i.descripcion = "Cada dos años y medio."
  i.metodo = "Revisión de la Ley Electoral vigente."
end
v5 = Variable.find_or_create_by!(particularidad: p4, nombre: "Elecciones de diputados a la ANPP") do |v|
  v.descripcion = "Renovación de la Asamblea Nacional del Poder Popular."
end
Indicador.find_or_create_by!(variable: v5, nombre: "Periodicidad") do |i|
  i.descripcion = "Cada cinco años."
  i.metodo = "Revisión de la Ley Electoral vigente."
end

p5 = Particularidad.find_or_create_by!(sistema: s_constitucional, titulo: "Derechos, deberes y garantías") do |p|
  p.descripcion = "Reconocimiento constitucional de derechos y garantías de las personas."
end
v6 = Variable.find_or_create_by!(particularidad: p5, nombre: "Derechos sociales") do |v|
  v.descripcion = "Derechos a la salud, la educación, el trabajo y la seguridad social."
end
Indicador.find_or_create_by!(variable: v6, nombre: "Reconocimiento y ejercicio") do |i|
  i.descripcion = "Instituciones que garantizan el ejercicio de los derechos sociales."
  i.metodo = "Revisión documental del capítulo de derechos de la Constitución."
end
v7 = Variable.find_or_create_by!(particularidad: p5, nombre: "Reforma constitucional") do |v|
  v.descripcion = "Mecanismo de modificación de la Constitución."
end
Indicador.find_or_create_by!(variable: v7, nombre: "Procedimiento de reforma") do |i|
  i.descripcion = "Iniciativa, mayoría requerida y referendo."
  i.metodo = "Revisión del título XV de la Constitución de 2019."
end

# Países tipo por continente
paises_tipo = [
  [ "México", :america, "Norteamérica", "República federal representativa y democrática." ],
  [ "Brasil", :america, "Sudamérica", "República federal presidencialista." ],
  [ "España", :europa, "Europa occidental", "Monarquía parlamentaria." ],
  [ "Alemania", :europa, "Europa central", "República federal parlamentaria." ],
  [ "Sudáfrica", :africa, "África austral", "República con sistema de democracia multipartidista." ],
  [ "Nigeria", :africa, "África occidental", "República federal presidencialista." ],
  [ "China", :asia, "Asia oriental", "República popular con sistema socialista." ],
  [ "India", :asia, "Asia meridional", "República parlamentaria federal." ]
]
paises_tipo.each do |nombre, continente, region, descripcion|
  pais = Pais.find_or_create_by!(nombre: nombre) do |p|
    p.continente = continente
    p.region = region
    p.descripcion = descripcion
  end
  sistema!(pais, :politico, "Organización política del país (formato general; completar con datos del proyecto).")
  sistema!(pais, :electoral, "Mecanismos electorales y de representación (completar con datos del proyecto).")
  sistema!(pais, :constitucional, "Marco constitucional y organización jurídica (completar con datos del proyecto).")
end

# M4 - Reglas del chatbot
reglas = [
  [ "definicion_concepto", "que es;que significa;definicion;que se entiende por",
   "Te explicaré el concepto solicitado." ],
  [ "documentos_tema", "documentos;hay documentos;articulos;literatura",
   "Te muestro los documentos relacionados." ],
  [ "sistema_pais", "sistema;electoral;constitucional;politico",
   "Te muestro el sistema del país mencionado." ],
  [ "recursos_tic", "tic;tep;tac;inteligencia artificial;redes sociales;ciberseguridad;recursos",
   "Te muestro recursos didácticos relacionados." ],
  [ "informacion_general", "hola;buenas;saludos;ayuda;que puedes hacer;qué puedes hacer",
   "Hola, soy el asistente del Repositorio Teoría Política. Puedo ayudarte con: definiciones de conceptos, documentos del proyecto, sistemas políticos de países y recursos didácticos. Intenta con «¿Qué es la soberanía?» o «Sistema electoral de Cuba»." ],
  [ "agradecimiento", "gracias;muchas gracias;genial;perfecto",
   "¡De nada! Puedes seguir preguntándome cuando quieras." ]
]
reglas.each do |intent, keywords, respuesta|
  Regla.find_or_create_by!(intent: intent) do |r|
    r.keywords = keywords
    r.respuesta = respuesta
    r.activa = true
  end
end

# M5 - Recursos didácticos (uno por ámbito: TIC, TEP, TAC, IA)
recursos = [
  [ "Uso de las TIC en la enseñanza de la Teoría Política", :material,
   "Material didáctico sobre la introducción de las Tecnologías de la Información y la Comunicación en el proceso de enseñanza-aprendizaje de la asignatura." ],
  [ "Taller: análisis crítico de la información en redes sociales", :actividad,
   "Actividad para el trabajo con los estudiantes sobre verificación de fuentes y uso crítico y valorativo de las redes sociales." ],
  [ "TEP y participación ciudadana digital", :bibliografia,
   "Bibliografía sobre las Tecnologías del Empoderamiento y la Participación en los procesos políticos." ],
  [ "Ciberseguridad y ciudadanía digital", :enlace,
   "Recurso sobre la respuesta educativa a la cibersubversión y la protección de la información." ],
  [ "Inteligencia Artificial responsable en el aula", :material,
   "Material sobre el uso inteligente y responsable de la IA en el proceso de enseñanza-aprendizaje." ]
]
recursos.each do |titulo, tipo, descripcion|
  RecursoDidactico.find_or_create_by!(titulo: titulo) do |r|
    r.tipo = tipo
    r.descripcion = descripcion
    r.estado = :publicado
  end
end

# Fase 6 - Secciones institucionales
# Acerca de nosotros: Misión, Visión y Estrategia; y Teoría de la conspiración
[
  [ "mision", "Misión",
   "El Repositorio Teoría Política es el resultado del proyecto institucional NA223LH508-012 " \
   "del Ministerio de Educación Superior (MES). Su misión es poner a disposición de estudiantes, " \
   "docentes e investigadores un fondo consultable de conceptos, documentación científica, " \
   "sistemas políticos comparados y recursos didácticos, con énfasis en el uso crítico de las " \
   "TIC, las TEP, las TAC y la Inteligencia Artificial.\n\n" \
   "Desde esta sección podrá acceder a los principales enlaces institucionales y de referencia del proyecto." ],
  [ "vision", "Visión",
   "Ser la obra de referencia para la enseñanza y el estudio de la Teoría Política en Cuba, " \
   "combinando el rigor académico con el aprovechamiento crítico de las tecnologías digitales.\n\n" \
   "Formar ciudadanos con pensamiento político propio, capaces de comprender, analizar y valorar " \
   "los distintos sistemas políticos y de participar responsablemente en la esfera cívica, sobre " \
   "la base del conocimiento científico y del valor de la información verificada." ],
  [ "estrategia", "Estrategia",
   "Desarrollar la plataforma de forma escalonada en fases:\n\n" \
   "Fase 1 – Fondo inicial: conceptos, documentación científica y sistemas políticos comparados.\n" \
   "Fase 2 – Recursos didácticos: materiales y actividades para las TIC, las TEP, las TAC y la Inteligencia Artificial en el aula.\n" \
   "Fase 3 – Secciones interactivas: teoría de la conspiración y análisis crítico de discursos y narrativas.\n" \
   "Fase 4 – Evaluación continua: revisión por especialistas y retroalimentación de docentes y estudiantes." ]
].each do |clave, titulo, cuerpo|
  Seccion.find_or_create_by!(clave: clave) do |s|
    s.titulo = titulo
    s.cuerpo = cuerpo
  end
end
Seccion.find_or_create_by!(clave: "teoria_conspiracion") do |s|
  s.titulo = "Teoría de la conspiración"
  s.cuerpo = "Colección de enlaces de interés para el estudio crítico de los discursos y narrativas " \
             "conspirativas: fuentes, análisis, materiales audiovisuales y documentos desclasificados. " \
             "Los enlaces apuntan a plataformas externas; el repositorio no aloja esos contenidos."
end

enlaces_placeholder = [
  [ "mision", "Spanish Revolutions", "https://spanishrevolutions.com",
   "Plataforma de referencia del proyecto (placeholder)." ],
  [ "mision", "Sitio institucional MES", "https://www.mes.gob.cu",
   "Ministerio de Educación Superior (MES)." ],
  [ "teoria_conspiracion", "Spanish Revolutions", "https://spanishrevolutions.com",
   "Narrativas y análisis en español (placeholder)." ],
  [ "teoria_conspiracion", "Willian (canal/portal)", "https://example.com/willian",
   "Materiales audiovisuales del autor (placeholder)." ],
  [ "teoria_conspiracion", "Documentos desclasificados de la CIA (CREST)", "https://www.cia.gov/readingroom/",
   "Archivo de documentos desclasificados de la CIA (placeholder)." ],
  [ "teoria_conspiracion", "Riadni en Facebook", "https://www.facebook.com/riadni",
   "Red social del proyecto Riadni (placeholder)." ]
]
enlaces_placeholder.each do |clave, titulo, url, descripcion|
  seccion = Seccion.find_by!(clave: clave)
  Enlace.find_or_create_by!(seccion: seccion, url: url) do |e|
    e.titulo = titulo
    e.descripcion = descripcion
  end
end

Configuracion::CLAVES.each do |clave|
  Configuracion.find_or_create_by!(clave: clave) do |c|
    c.valor = Configuracion::VALORES_DEFECTO.fetch(clave)
  end
end

# Catálogo histórico de sistemas de gobierno (página /sistemas)
SISTEMAS_GOBIERNO = {
  # Sociedad primitiva
  "Comunismo primitivo" => { etapa: "sociedad_primitiva", orden: 0, descripcion: "Primera forma de organización social sin clases ni propiedad privada; los medios de producción pertenecían a la comunidad y el trabajo se repartía según las necesidades grupales." },
  "Sociedad gentilicia" => { etapa: "sociedad_primitiva", orden: 1, descripcion: "Organización por gens o clanes basada en el parentesco; el poder descansaba en asambleas de la comunidad y en jefes elegidos, sin aparato estatal." },
  "Jefatura tribal" => { etapa: "sociedad_primitiva", orden: 2, descripcion: "Gobierno de una tribu por un jefe o cacique que concentra autoridad política, religiosa o militar, con poder limitado por los consejos y las tradiciones." },
  "Consejo de ancianos" => { etapa: "sociedad_primitiva", orden: 3, descripcion: "Órgano consultivo y de decisión compuesto por los miembros de mayor edad y experiencia, típico de muchas sociedades preestatales." },
  # Esclavismo
  "Despotismo oriental" => { etapa: "esclavismo", orden: 0, descripcion: "Modo de producción asiático: Estado centralizado y despótico que controla grandes obras colectivas, con comunidades sometidas a tributos y a un soberano absoluto." },
  "Monarquía esclavista" => { etapa: "esclavismo", orden: 1, descripcion: "Monarquías del mundo antiguo (Egipto, Mesopotamia) donde la economía y el poder se sostienen en el trabajo esclavo y en la divinización del gobernante." },
  "Tiranía griega" => { etapa: "esclavismo", orden: 2, descripcion: "Gobierno personal de los tiranos griegos (siglos VII-VI a. C.), frecuentemente apoyados en las clases populares contra la aristocracia, sin someterse a leyes estables." },
  "Democracia esclavista" => { etapa: "esclavismo", orden: 3, descripcion: "Democracia directa de la Atenas clásica: gobierno de ciudadanos libres con participación en asambleas, sobre una base económica esclavista que excluía a mujeres, esclavos y extranjeros." },
  "República esclavista" => { etapa: "esclavismo", orden: 4, descripcion: "Régimen de la República romana: gobierno de magistrados, senado y asambleas, reservado a ciudadanos, con la esclavitud como pilar de la producción." },
  # Feudalismo
  "Monarquía feudal" => { etapa: "feudalismo", orden: 0, descripcion: "Monarquía medieval en la que el rey es el primero entre los señores feudales y su poder depende de la lealtad y los vínculos vasalláticos, no de un Estado centralizado." },
  "Monarquía estamental" => { etapa: "feudalismo", orden: 1, descripcion: "Monarquía que gobierna junto a los estamentos (nobleza, clero y tercer estado) a través de cortes o asambleas que votan impuestos y limitan el poder real." },
  "Teocracia feudal" => { etapa: "feudalismo", orden: 2, descripcion: "Formas de gobierno en que la autoridad religiosa y la política se funden, como los Estados pontificios o los principados eclesiásticos medievales." },
  "Señorío y vasallaje" => { etapa: "feudalismo", orden: 3, descripcion: "Ejercicio local del poder del señor sobre su feudo: justicia, tributos y protección sobre los campesinos, dentro de la red de relaciones de vasallaje." },
  # Absolutismo
  "Monarquía absoluta" => { etapa: "absolutismo", orden: 0, descripcion: "Monarquía en la que el rey concentra el poder legislativo, ejecutivo y judicial sin rendir cuentas, legitimado por la teoría del derecho divino (Luis XIV, Fernando VII)." },
  "Despotismo ilustrado" => { etapa: "absolutismo", orden: 1, descripcion: "Absolutismo que adopta reformas ilustradas 'todo para el pueblo pero sin el pueblo', como las de Federico II de Prusia o Catalina II de Rusia." },
  "Monarquía constitucional" => { etapa: "absolutismo", orden: 2, descripcion: "Tránsito hacia el Estado liberal: el rey queda limitado por una constitución y por un parlamento, como en la Inglaterra post-gloriosa o las monarquías del siglo XIX." },
  # Capitalismo y sus ramas
  "Capitalismo mercantil" => { etapa: "capitalismo", orden: 0, descripcion: "Capitalismo comercial de los siglos XVI-XVIII: acumulación de capital mediante el comercio colonial, el mercantilismo y el monopolio estatal de los intercambios." },
  "Capitalismo industrial" => { etapa: "capitalismo", orden: 1, descripcion: "Capitalismo surgido de la Revolución Industrial: predominio de la gran industria, el trabajo asalariado y la burguesía industrial como clase dominante." },
  "Capitalismo financiero" => { etapa: "capitalismo", orden: 2, descripcion: "Etapa en que los bancos y las finanzas dominan la economía, subordinando el capital industrial al capital bancario, señalada por Hilferding y analizada por Lenin." },
  "Capitalismo monopolista" => { etapa: "capitalismo", orden: 3, descripcion: "Capitalismo de los grandes trusts, carteles y corporaciones, con tendencia a la concentración del mercado y al imperialismo como extensión de esa lógica." },
  "Capitalismo de Estado" => { etapa: "capitalismo", orden: 4, descripcion: "Capitalismo en el que el Estado interviene como gran propietario, inversor o regulador: desde las empresas públicas hasta los planes de industrialización dirigida." },
  "Capitalismo de bienestar" => { etapa: "capitalismo", orden: 5, descripcion: "Capitalismo regulado por el Estado de bienestar y el keynesianismo de posguerra: redistribución, seguridad social y negociación colectiva dentro de la economía de mercado." },
  "Capitalismo periférico" => { etapa: "capitalismo", orden: 6, descripcion: "Capitalismo de los países dependientes o subdesarrollados, según la teoría de la dependencia, que exportan materias primas e importan bienes y capital del centro." },
  "Capitalismo rentista" => { etapa: "capitalismo", orden: 7, descripcion: "Modelo basado en la captura de rentas (petroleras, extractivas o de activos financieros) sin desarrollo productivo, asociado a estados rentistas o economías de enclave." },
  "Capitalismo de plataformas" => { etapa: "capitalismo", orden: 8, descripcion: "Forma actual centrada en las grandes plataformas digitales que extraen valor de los datos y del trabajo gig, concentrando poder tecnológico y de mercado." },
  "Anarcocapitalismo" => { etapa: "capitalismo", orden: 9, descripcion: "Propuesta de eliminar el Estado y organizar la sociedad mediante contratos privados, propiedad y libre mercado, con servicios (incluida la seguridad) privatizados." },
  "Capitalismo tardío" => { etapa: "capitalismo", orden: 10, descripcion: "Concepto (Mandel, Jameson) para la fase contemporánea: financiarización global, producción flexible y cultura posmoderna en el vértice \u2013nunca materializado\u2013 de su lógica." },
  # Socialismo y sus variantes
  "Socialismo utópico" => { etapa: "socialismo", orden: 0, descripcion: "Socialistas previos a Marx (Owen, Fourier, Saint-Simon) que proponían comunidades ideales y reformas morales más que la revolución política." },
  "Socialismo científico" => { etapa: "socialismo", orden: 1, descripcion: "Socialismo fundado por Marx y Engels con base en el análisis materialista de la historia: la clase trabajadora como sujeto de la transformación social." },
  "Socialismo democrático" => { etapa: "socialismo", orden: 2, descripcion: "Corriente que busca el socialismo por vías democráticas, con sindicatos, parlamentos y elecciones, combinando justicia social con libertades políticas." },
  "Socialdemocracia" => { etapa: "socialismo", orden: 3, descripcion: "Socialismo reformista que acepta la economía de mercado regulada: Estado de bienestar, impuestos progresivos y políticas de pleno empleo." },
  "Socialismo de mercado" => { etapa: "socialismo", orden: 4, descripcion: "Propuesta de combinar propiedad o gestión social de los medios de producción con mecanismos de mercado, como en China, Vietnam o los modelos de autogestión." },
  "Socialismo de Estado" => { etapa: "socialismo", orden: 5, descripcion: "Socialismo en que el Estado (partido-Estado) planifica y dirige la economía, como la URSS bajo la planificación centralizada." },
  "Anarcosindicalismo" => { etapa: "socialismo", orden: 6, descripcion: "Corriente que busca la autogestión de los trabajadores mediante sindicatos; los sindicatos organizan la producción y la lucha, sin Estado ni partidos." },
  "Anarcocomunismo" => { etapa: "socialismo", orden: 7, descripcion: "Variante del anarquismo (Kropotkin) que aboga por la abolición del Estado y de la propiedad privada, con comunas federadas y distribución según las necesidades." },
  "Socialismo del siglo XXI" => { etapa: "socialismo", orden: 8, descripcion: "Propuesta latinoamericana (relanzada por la Revolución Bolivariana) de un socialismo participativo y antiimperialista para el siglo XXI." },
  "Eurocomunismo" => { etapa: "socialismo", orden: 9, descripcion: "Corriente de los partidos comunistas de Europa occidental (Italia, España, Francia) que aspira al socialismo por vías democráticas y pluralistas, distanciada de Moscú." },
  # Comunismo
  "Comunismo" => { etapa: "comunismo", orden: 0, descripcion: "Sociedad sin clases ni Estado prevista por el marxismo como fase superior del desarrollo social, tras la extinción de la dominación de clase y la superación de la escasez." },
  # Sistemas no materializados o ideales
  "Comunismo pleno" => { etapa: "no_materializados", orden: 0, descripcion: "Fase superior del comunismo descrita por Marx: 'de cada cual según sus capacidades, a cada cual según sus necesidades'; nunca se ha materializado en la historia." },
  "Tecnocracia" => { etapa: "no_materializados", orden: 1, descripcion: "Gobierno de los técnicos y expertos que toman decisiones según criterios científicos y de eficiencia, en lugar de la política tradicional; se ha planteado pero no aplicado plenamente." },
  "Tecno-oligarquía" => { etapa: "no_materializados", orden: 2, descripcion: "Forma hipotética donde el poder real recae en un pequeño grupo de élites tecnológicas que controlan los datos, la inteligencia artificial y la infraestructura digital." },
  "Netocracia" => { etapa: "no_materializados", orden: 3, descripcion: "Gobierno hipotético de la 'clase de la red': el poder se desplazaría a quienes dominan el conocimiento, la conectividad y los flujos de información." },
  "Meritocracia" => { etapa: "no_materializados", orden: 4, descripcion: "Gobierno otorgado según el mérito (talento y esfuerzo) más que por herencia o riqueza; como sistema pleno sigue siendo un ideal controvertido y no realizado." },
  "Estado mínimo" => { etapa: "no_materializados", orden: 5, descripcion: "Propuesta libertaria (Nozick) de un Estado limitado a la protección de derechos y contratos, sin redistribución; nunca adoptada en forma pura." },
  "Estado mundial" => { etapa: "no_materializados", orden: 6, descripcion: "Idea de un gobierno único a escala planetaria, ya sea confederal o centralizado, que resolvería los conflictos interestatales; no se ha materializado." },
  "Anarquía sin Estado" => { etapa: "no_materializados", orden: 7, descripcion: "Sociedad sin coerción estatal basada en la autoorganización y el apoyo mutuo; enunciada por el anarquismo, no alcanzada de forma sostenida en escala amplia." },
  # Otros conceptos de la ciencia política
  "Democracia representativa" => { etapa: "otros_conceptos", orden: 0, descripcion: "Sistema en el que los ciudadanos eligen periódicamente a representantes que deciden en su nombre, forma dominante del gobierno democrático contemporáneo." },
  "Democracia directa" => { etapa: "otros_conceptos", orden: 1, descripcion: "Participación del pueblo directamente en las decisiones (asambleas, referendos e iniciativas populares) sin intermediación de representantes." },
  "República" => { etapa: "otros_conceptos", orden: 2, descripcion: "Forma de gobierno en la que el jefe de Estado se elige y rinde cuentas, contrapuesta a la monarquía; el poder se entiende como cosa pública y sujeta a leyes." },
  "Monarquía electiva" => { etapa: "otros_conceptos", orden: 3, descripcion: "Monarquía en la que el rey no se hereda sino que se elige, como históricamente en el Sacro Imperio Romano Germánico o Polonia." },
  "Aristocracia" => { etapa: "otros_conceptos", orden: 4, descripcion: "Gobierno de 'los mejores': una minoría considerada superior por su linaje, virtud o saber, como en la Esparta antigua." },
  "Oligarquía" => { etapa: "otros_conceptos", orden: 5, descripcion: "Gobierno de un pequeño grupo que ejerce el poder en beneficio propio, sin rendir cuentas ante la mayoría." },
  "Plutocracia" => { etapa: "otros_conceptos", orden: 6, descripcion: "Forma de oligarquía en la que el poder real lo detentan los más ricos, influyendo el gobierno por medios económicos." },
  "Autocracia" => { etapa: "otros_conceptos", orden: 7, descripcion: "Gobierno de una sola persona con poder absoluto e ilimitado, sin controles constitucionales ni oposición efectiva." },
  "Totalitarismo" => { etapa: "otros_conceptos", orden: 8, descripcion: "Régimen que busca controlar todos los ámbitos de la vida mediante un partido único, ideología oficial y terror, según el análisis de Arendt." },
  "Autoritarismo" => { etapa: "otros_conceptos", orden: 9, descripcion: "Régimen con poder concentrado y libertades restringidas, pero sin el control total e ideológico de la vida social propio del totalitarismo." },
  "Timocracia" => { etapa: "otros_conceptos", orden: 10, descripcion: "Gobierno basado en el honor y la propiedad, descrito por Platón: el poder corresponde a quienes ponen por encima la ambición de fama y distinción." },
  "Teocracia" => { etapa: "otros_conceptos", orden: 11, descripcion: "Gobierno en el que la autoridad religiosa detenta el poder político en nombre de una divinidad y sus normas se imponen como ley." },
  "Estado de derecho" => { etapa: "otros_conceptos", orden: 12, descripcion: "Organización en la que todos los poderes están sometidos a la ley y a controles, garantizando derechos fundamentales y separación de funciones." },
  "Despotismo" => { etapa: "otros_conceptos", orden: 13, descripcion: "Ejercicio arbitrario y sin límites del poder por un gobernante que trata a los súbditos como súbditos de su voluntad." }
}

SISTEMAS_GOBIERNO.each do |nombre, datos|
  SistemaGobierno.find_or_create_by!(nombre: nombre) do |s|
    s.etapa = datos[:etapa]
    s.orden = datos[:orden]
    s.estado = :publicado
    s.descripcion = datos[:descripcion]
  end
end

puts "Seeds cargados: #{User.count} usuarios, #{Tema.count} temas, #{Concepto.count} conceptos, " \
     "#{Documento.count} documentos, #{Pais.count} países, #{Sistema.count} sistemas, " \
     "#{Regla.count} reglas, #{RecursoDidactico.count} recursos didácticos, " \
     "#{Seccion.count} secciones, #{Enlace.count} enlaces, #{Configuracion.count} configuraciones, " \
     "#{SistemaGobierno.count} sistemas de gobierno."
