require "test_helper"

class CrudTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "visitante ve todas las páginas públicas" do
    rutas = [root_path, conceptos_path, documentos_path, paises_path, cuba_path,
             comparativa_path, analisis_path, chat_index_path, recursos_didacticos_path,
             acerca_path, teoria_de_la_conspiracion_path]
    rutas.each do |ruta|
      get ruta
      assert_response :success, "Fallo en #{ruta}"
    end
  end

  test "visitante no puede crear conceptos" do
    get new_concepto_path
    assert_redirected_to root_path
    assert_no_difference("Concepto.count") do
      post conceptos_path, params: {
        concepto: { termino: "Anarquismo", definicion: "Doctrina.", tema_id: temas(:estado).id }
      }
    end
    assert_redirected_to root_path
  end

  test "visitante no puede gestionar reglas (solo admin)" do
    get reglas_path
    assert_redirected_to root_path
    assert_no_difference("Regla.count") do
      post reglas_path, params: { regla: { intent: "x", keywords: "y", activa: true } }
    end
  end

  test "editor puede crear y ver un concepto publicado" do
    sign_in users(:editor)
    assert_difference("Concepto.count", 1) do
      post conceptos_path, params: {
        concepto: {
          termino: "Soberanía popular", definicion: "El pueblo como titular del poder.",
          sinonimos: "Soberanía nacional", categoria: "Poder",
          tema_id: temas(:estado).id, estado: "publicado"
        }
      }
    end
    assert_redirected_to concepto_path(Concepto.last)
    get concepto_path(Concepto.last)
    assert_response :success
    assert_select "div", /El pueblo como titular del poder/
  end

  test "editor puede crear un país" do
    sign_in users(:editor)
    assert_difference("Pais.count", 1) do
      post paises_path, params: {
        pais: { nombre: "Venezuela", continente: "america", region: "Sudamérica", descripcion: "República bolivariana." }
      }
    end
    assert_redirected_to pais_path(Pais.last)
  end

  test "editor no puede crear reglas (solo admin)" do
    sign_in users(:editor)
    assert_no_difference("Regla.count") do
      post reglas_path, params: { regla: { intent: "x", keywords: "y", activa: true } }
    end
    assert_redirected_to root_path
  end

  test "admin puede crear una regla" do
    sign_in users(:admin)
    assert_difference("Regla.count", 1) do
      post reglas_path, params: {
        regla: { intent: "saludo_extra", keywords: "holi", respuesta: "Hola", activa: true }
      }
    end
    assert_redirected_to regla_path(Regla.last)
  end

  test "página de Cuba muestra particularidades" do
    get cuba_path
    assert_response :success
    assert_select "h1", /Cuba/
    assert_select ".accordion-item", minimum: 1
  end

  test "chat responde consultas y registra el log" do
    sign_in users(:editor)
    post consultar_chat_index_path, params: { pregunta: "¿Qué es la soberanía?" }, as: :json
    assert_response :success
    assert JSON.parse(response.body)["respuesta"].present?
    assert_difference("ChatLog.count", 1) do
      post consultar_chat_index_path, params: { pregunta: "¿Qué es la soberanía?" }, as: :json
    end
  end
end
