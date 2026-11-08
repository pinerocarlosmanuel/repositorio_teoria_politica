require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "rol por defecto es visitante" do
    usuario = User.create!(email: "visitante@proyecto.cu", password: "password123", nombre: "Visitante")
    assert usuario.visitante?
    assert_not usuario.admin?
  end

  test "admin y editor devuelven roles correctos" do
    assert users(:admin).admin?
    assert users(:editor).editor?
    assert_not users(:admin).editor?
  end
end
