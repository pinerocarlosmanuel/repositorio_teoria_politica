module Api
  module V1
    class DocumentosController < ApplicationController
      def index
        @documentos = Documento.publicados.order(:titulo).limit(200)
        render json: @documentos.as_json(
          only: %i[id titulo autores anio resumen referencia tipo url doi],
          methods: :archivo_url
        )
      end
    end
  end
end
