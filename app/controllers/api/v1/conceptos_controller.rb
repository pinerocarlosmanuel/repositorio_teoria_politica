module Api
  module V1
    class ConceptosController < ApplicationController
      def index
        @conceptos = Concepto.publicados.order(:termino).limit(200)
        render json: @conceptos.as_json(
          only: %i[id termino definicion sinonimos categoria fuente],
          include: { tema: { only: %i[id nombre] } }
        )
      end

      def show
        @concepto = Concepto.publicados.find(params[:id])
        render json: @concepto.as_json(
          only: %i[id termino definicion sinonimos categoria fuente],
          include: { tema: { only: %i[id nombre] } }
        )
      end
    end
  end
end
