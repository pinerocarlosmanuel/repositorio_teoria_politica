class HomeController < ApplicationController
  def index
    @total_conceptos = Concepto.publicados.count
    @total_documentos = Documento.publicados.count
    @total_paises = Pais.count
    @total_recursos = RecursoDidactico.publicados.count
    @conceptos_recientes = Concepto.publicados.order(updated_at: :desc).limit(5)
    @documentos_recientes = Documento.publicados.order(updated_at: :desc).limit(5)
  end

  def buscar
    q = params[:q].to_s.strip
    @q = q
    if q.present?
      @conceptos = Concepto.publicados.busqueda(q).limit(5)
      @documentos = Documento.publicados.busqueda(q).limit(5)
      @paises = Pais.where("nombre ILIKE ? OR descripcion ILIKE ?", "%#{q}%", "%#{q}%").limit(5)
      @recursos = RecursoDidactico.publicados.busqueda(q).limit(5)
    else
      @conceptos = @documentos = @paises = @recursos = []
    end
  end
end
