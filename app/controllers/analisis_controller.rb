class AnalisisController < ApplicationController
  def index
    @total_conceptos = Concepto.publicados.count
    @total_documentos = Documento.publicados.count
    @total_recursos = RecursoDidactico.publicados.count
    @total_paises = Pais.count
    @total_sistemas = Sistema.count

    @conceptos_por_tema = Tema.all.to_h { |t| [t.nombre, t.conceptos.publicados.count] }
    @documentos_por_tipo = Documento.publicados.group(:tipo).count
    @recursos_por_tipo = RecursoDidactico.publicados.group(:tipo).count
    @sistemas_por_tipo = Sistema.group(:tipo).count
    @documentos_por_anio = Documento.publicados.where.not(anio: nil).group(:anio).count.sort.to_h
    @paises_por_continente = Pais.group(:continente).count
    @sistemas_por_pais_tipo = Pais.includes(sistemas: :particularidades).map do |p|
      [p, { por_tipo: p.sistemas.group(:tipo).count, completos: p.sistemas.count { |s| s.particularidades.any? } }]
    end.select { |_, h| h[:por_tipo].any? }
  end

  # GET /analisis/comparar?paises=1,2,3 (JSON) — comparativa real de contenido
  def comparar
    ids = params[:paises].to_s.split(",").map(&:to_i).uniq
    paises = Pais.where(id: ids).order(:nombre)

    sistemas_por_tipo = {}
    particularidades = Hash.new { |h, k| h[k] = {} }
    variables = Hash.new { |h, k| h[k] = {} }
    indicadores = Hash.new { |h, k| h[k] = {} }

    resumen = paises.map do |pais|
      stats = estadisticas_pais(pais)
      pais.sistemas.includes(particularidades: { variables: :indicadores }).each do |sistema|
        sistemas_por_tipo[sistema.tipo] ||= {}
        sistemas_por_tipo[sistema.tipo][pais.id] = {
          descripcion: sistema.descripcion,
          particularidades: sistema.particularidades.size
        }
        sistema.particularidades.each do |pt|
          particularidades[pt.titulo][pais.id] = pt.variables.size
          pt.variables.each do |v|
            variables[v.nombre][pais.id] = v.indicadores.size
            v.indicadores.each do |i|
              indicadores[i.nombre][pais.id] = (indicadores[i.nombre][pais.id] || 0) + 1
            end
          end
        end
      end
      { id: pais.id, sistemas: stats[:sistemas], particularidades: stats[:particularidades],
        variables: stats[:variables], indicadores: stats[:indicadores], por_tipo: stats[:por_tipo] }
    end

    render json: {
      paises: paises.map { |p| { id: p.id, nombre: p.nombre } },
      resumen: resumen,
      tipos: Sistema.tipos.keys,
      etiquetas: Sistema.tipos.keys.to_h { |t| [t, I18n.t("enums.sistema.tipo.#{t}")] },
      sistemas_por_tipo: sistemas_por_tipo,
      particularidades: particularidades,
      variables: variables,
      indicadores: indicadores
    }
  end

  private

  def estadisticas_pais(pais)
    return {} unless pais

    ids = pais.sistemas.ids
    {
      pais: pais,
      sistemas: ids.size,
      por_tipo: pais.sistemas.group(:tipo).count,
      particularidades: Particularidad.where(sistema_id: ids).count,
      variables: Variable.joins(:particularidad).where(particularidades: { sistema_id: ids }).count,
      indicadores: Indicador.joins(variable: :particularidad).where(particularidades: { sistema_id: ids }).count
    }
  end
end
