require "test_helper"

class PaisTest < ActiveSupport::TestCase
  test "validaciones y países destacados" do
    assert_not Pais.new.valid?
    assert_includes Pais.destacados, paises(:cuba)
  end

  test "un sistema por tipo y país" do
    duplicado = Sistema.new(pais: paises(:cuba), tipo: :politico, descripcion: "x")
    assert_not duplicado.valid?
  end
end
