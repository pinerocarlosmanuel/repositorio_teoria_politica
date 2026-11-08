require "test_helper"

class AuthTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "la página de login carga" do
    get new_user_session_path
    assert_response :success
    assert_select ".auth-title", text: /Repositorio Teoría Política/i
    assert_select "input[name='user[email]']"
    assert_select "input[name='user[password]']"
    assert_select "input[type='submit'][value='Iniciar sesión']"
  end

  test "login con credenciales válidas redirige al inicio" do
    post user_session_path, params: {
      user: { email: "admin@proyecto.cu", password: "password" }
    }
    assert_redirected_to root_path
  end

  test "login con credenciales inválidas no autentica" do
    post user_session_path, params: {
      user: { email: "admin@proyecto.cu", password: "incorrecta" }
    }
    assert_response :unprocessable_content
  end

  test "usuario autenticado ve su rol en la barra" do
    sign_in users(:admin)
    get root_path
    assert_select ".navbar-text", text: /Administrador/
  end
end
