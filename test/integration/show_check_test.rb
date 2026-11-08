require "test_helper"

class ShowCheckTest < ActionDispatch::IntegrationTest
  test "show de recurso didactico funciona" do
    get recursos_didacticos_path
    assert_response :success
    r = RecursoDidactico.order(:id).first
    get recurso_didactico_path(r)
    assert_response :success
    assert_select "h1", /#{r.titulo}/
  end

  test "show de pais funciona" do
    p = Pais.order(:id).first
    get pais_path(p)
    assert_response :success
  end
end
