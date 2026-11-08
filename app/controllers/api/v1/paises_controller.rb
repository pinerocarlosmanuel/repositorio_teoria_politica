module Api
  module V1
    class PaisesController < ApplicationController
      def index
        @paises = Pais.order(:nombre)
        render json: @paises.as_json(
          only: %i[id nombre continente region descripcion],
          methods: :sistemas_resumen
        )
      end
    end
  end
end
