require "test_helper"

class AdminDashboardTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "visitante no accede al panel de administración" do
    get administracion_path
    assert_redirected_to root_path
  end

  test "editor no accede al panel de administración" do
    sign_in users(:editor)
    get administracion_path
    assert_redirected_to root_path
  end

  test "el panel de administración lleva directamente al hub de pestañas" do
    sign_in users(:admin)
    get administracion_path
    assert_redirected_to configuraciones_path
    follow_redirect!
    assert_response :success
    assert_select "h1", /Administración del sitio/
    assert_select "ul.nav-tabs a", text: "Usuarios"
    assert_select "ul.nav-tabs a", text: "Secciones"
    assert_select "ul.nav-tabs a", text: "Enlaces"
  end

  test "el menú de administración enlaza al panel" do
    sign_in users(:admin)
    get root_path
    assert_response :success
    assert_select "nav a[href='#{administracion_path}']", text: "Administración"
  end
end
