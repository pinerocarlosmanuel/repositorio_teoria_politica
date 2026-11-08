# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, "\\1en"
#   inflect.singular /^(ox)en/i, "\\1"
#   inflect.irregular "person", "people"
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym "RESTful"
# end

# Español: paises y sus derivados (Pais -> paises)
ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular "pais", "paises"
  inflect.irregular "seccion", "secciones"
  inflect.irregular "particularidad", "particularidades"
  inflect.irregular "indicador", "indicadores"
  inflect.irregular "referencia", "referencias"
  inflect.irregular "configuracion", "configuraciones"
  inflect.irregular "recurso_didactico", "recursos_didacticos"
end
