require "test_helper"

class AnalisisCompararTest < ActionDispatch::IntegrationTest
  test "devuelve comparativa real de contenido para los países seleccionados" do
    ids = Pais.order(:id).limit(2).pluck(:id).join(",")
    get analisis_comparar_path, params: { paises: ids }, as: :json
    assert_response :success
    body = JSON.parse(response.body)

    assert_equal 2, body["paises"].size
    assert_equal 2, body["resumen"].size
    assert_equal %w[politico electoral constitucional], body["tipos"]
    assert body["sistemas_por_tipo"].is_a?(Hash)
    assert body["particularidades"].is_a?(Hash)
    assert body["variables"].is_a?(Hash)
    assert body["indicadores"].is_a?(Hash)

    r = body["resumen"].first
    %w[id sistemas particularidades variables indicadores por_tipo].each do |clave|
      assert r.key?(clave), "falta clave #{clave}"
    end
    assert r["por_tipo"].is_a?(Hash)
  end

  test "matriz de particularidades asocia cada título con los países" do
    ids = Pais.order(:id).limit(2).pluck(:id).join(",")
    get analisis_comparar_path, params: { paises: ids }, as: :json
    body = JSON.parse(response.body)

    body["particularidades"].each_value do |por_pais|
      assert_equal 2, por_pais.size
      por_pais.each_value { |n| assert n.is_a?(Integer) }
    end
  end

  test "ids vacíos devuelven comparativa sin países" do
    get analisis_comparar_path, params: { paises: "99999" }, as: :json
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal [], body["paises"]
    assert_equal [], body["resumen"]
  end
end
