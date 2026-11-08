require "test_helper"

class HomeTest < ActionDispatch::IntegrationTest
  test "la página de inicio carga y muestra el repositorio" do
    get root_path
    assert_response :success
    assert_select "h1", text: /Bienvenido al Repositorio Teoría Política/
  end

  test "la página de inicio muestra las estadísticas sembradas" do
    get root_path
    assert_response :success
    assert_select ".dspace-comunidad", text: /Conceptos \(Materias\)/
    assert_select ".dspace-comunidad", text: /Artículo/
    assert_select ".dspace-facet", minimum: 1
  end
end
