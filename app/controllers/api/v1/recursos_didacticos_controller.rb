module Api
  module V1
    class RecursosDidacticosController < ApplicationController
      def index
        @recursos = RecursoDidactico.publicados.order(:titulo).limit(200)
        render json: @recursos.as_json(
          only: %i[id titulo descripcion tipo referencia url]
        )
      end
    end
  end
end
