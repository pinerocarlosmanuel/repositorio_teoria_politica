require "test_helper"

class ApiTest < ActionDispatch::IntegrationTest
  test "GET /api/v1/conceptos devuelve solo conceptos publicados" do
    get api_v1_conceptos_path, as: :json
    assert_response :success
    datos = JSON.parse(response.body)
    assert datos.any? { |c| c["termino"] == "Poder político" }
    assert datos.none? { |c| c["termino"] == "Concepto borrador" }
    assert datos.all? { |c| c["tema"].is_a?(Hash) }
  end

  test "GET /api/v1/conceptos/:id devuelve un concepto publicado" do
    get api_v1_concepto_path(conceptos(:soberania).id), as: :json
    assert_response :success
    assert_equal "Soberanía", JSON.parse(response.body)["termino"]
  end

  test "GET /api/v1/documentos devuelve solo publicados" do
    get api_v1_documentos_path, as: :json
    assert_response :success
    datos = JSON.parse(response.body)
    assert datos.any? { |d| d["titulo"].include?("Ciberseguridad") }
  end

  test "GET /api/v1/paises incluye resumen de sistemas" do
    get api_v1_paises_path, as: :json
    assert_response :success
    datos = JSON.parse(response.body)
    cuba = datos.find { |p| p["nombre"] == "Cuba" }
    assert cuba["sistemas_resumen"].is_a?(Array)
    assert cuba["sistemas_resumen"].any? { |s| s.first == "politico" }
  end

  test "GET /api/v1/recursos_didacticos devuelve solo publicados" do
    get api_v1_recursos_didacticos_path, as: :json
    assert_response :success
    datos = JSON.parse(response.body)
    assert datos.any? { |r| r["titulo"].downcase.include?("ciberseguridad") }
  end

  test "búsqueda global del home devuelve resultados" do
    get buscar_path(q: "poder")
    assert_response :success
    assert_select "h1", /Buscar/
    assert_select ".dspace-resultados-tabla", minimum: 1
    assert_select ".dspace-facet", minimum: 1
  end
end
