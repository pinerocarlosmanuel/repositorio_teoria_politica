require "test_helper"

class ConfiguracionesTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "visitante no accede a la configuración general" do
    get configuraciones_path
    assert_redirected_to root_path
  end

  test "editor no accede a la configuración general" do
    sign_in users(:editor)
    get configuraciones_path
    assert_redirected_to root_path
  end

  test "admin ve las pestañas y los campos de cada sección" do
    sign_in users(:admin)

    get configuraciones_path(seccion: "portada")
    assert_response :success
    assert_select "input[name='configuracion[valor][titulo]']"
    assert_select "input[name='configuracion[valor][cta_label]']"

    get configuraciones_path(seccion: "front")
    assert_response :success
    assert_select "input[name='configuracion[valor][empresa]']"
    assert_select "input[name='configuracion[valor][email]']"
    assert_select "input[name='configuracion[valor][facebook]']"
    assert_select "input[name='configuracion[valor][interes1]']"

    get configuraciones_path(seccion: "ajustes")
    assert_response :success
    assert_select "input[name='configuracion[valor][main_color]']"

    get configuraciones_path(seccion: "menu")
    assert_response :success
    assert_select "input[name='configuracion[valor][items][][label]'][value='Acerca de nosotros']"
    assert_select "input[name='configuracion[valor][items][][url]'][value='/acerca']"

    get configuraciones_path(seccion: "acerca")
    assert_response :success
    assert_select "h2", /Acerca de nosotros/
  end

  test "admin actualiza la portada y el home la refleja" do
    sign_in users(:admin)
    patch configuraciones_path, params: {
      configuracion: {
        clave: "portada",
        valor: { titulo: "Título nuevo", descripcion: "Descripción de prueba", mostrar_carrusel: "1" }
      }
    }
    assert_redirected_to configuraciones_path(seccion: "portada")

    configuracion = Configuracion.find_by!(clave: "portada")
    assert_equal "Título nuevo", configuracion.valor["titulo"]

    get root_path
    assert_response :success
    assert_select "h1", /Título nuevo/
    assert_select "p", /Descripción de prueba/
  end

  test "admin actualiza la configuración general y el pie la refleja" do
    sign_in users(:admin)
    patch configuraciones_path, params: {
      configuracion: { clave: "front", valor: { empresa: "Nueva Empresa", slogan: "Nuevo slogan" } }
    }
    assert_redirected_to configuraciones_path(seccion: "front")

    configuracion = Configuracion.find_by!(clave: "front")
    assert_equal "Nueva Empresa", configuracion.valor["empresa"]

    get root_path
    assert_response :success
    assert_select "footer .h6", /Nueva Empresa/
    assert_select "footer .small", /Nuevo slogan/
  end

  test "admin ve las pestañas de gestión (usuarios, secciones, enlaces)" do
    sign_in users(:admin)
    get configuraciones_path
    assert_response :success
    assert_select "ul.nav-tabs a[href='#{configuraciones_path(seccion: "portada")}']"
    assert_select "ul.nav-tabs a[href='#{configuraciones_path(seccion: "usuarios")}']"
    assert_select "ul.nav-tabs a[href='#{configuraciones_path(seccion: "secciones")}']"
    assert_select "ul.nav-tabs a[href='#{configuraciones_path(seccion: "enlaces")}']"

    get configuraciones_path(seccion: "secciones")
    assert_response :success
    seccion = Seccion.order(:clave).first
    assert_select "a[href='#{edit_seccion_path(seccion)}']"

    get configuraciones_path(seccion: "enlaces")
    assert_response :success

    get configuraciones_path(seccion: "usuarios")
    assert_response :success
    assert_select "form[action='#{configuraciones_usuarios_path}']"
  end

  test "admin crea usuarios desde la pestaña Usuarios" do
    sign_in users(:admin)
    assert_difference("User.count", 1) do
      post configuraciones_usuarios_path, params: {
        user: { email: "nuevo@proyecto.cu", nombre: "Nuevo Usuario", rol: "editor",
                password: "secret123", password_confirmation: "secret123" }
      }
    end
    assert_redirected_to configuraciones_path(seccion: "usuarios")

    usuario = User.find_by!(email: "nuevo@proyecto.cu")
    assert_equal "editor", usuario.rol
  end

  test "admin cambia el rol de un usuario" do
    sign_in users(:admin)
    patch configuracion_usuario_path(users(:editor)), params: { user: { rol: "admin" } }
    assert_redirected_to configuraciones_path(seccion: "usuarios")
    assert_equal "admin", users(:editor).reload.rol
  end

  test "admin elimina a otro usuario pero no a sí mismo" do
    sign_in users(:admin)
    assert_difference("User.count", -1) do
      delete configuracion_usuario_path(users(:editor))
    end
    assert_redirected_to configuraciones_path(seccion: "usuarios")

    delete configuracion_usuario_path(users(:admin))
    assert User.exists?(users(:admin).id)
  end

  test "admin modifica el menú y la navegación lo refleja" do
    sign_in users(:admin)
    patch configuraciones_path, params: {
      configuracion: {
        clave: "menu",
        valor: {
          menu_logo: "",
          items: [
            { label: "Inicio", url: "/" },
            { label: "Nueva sección", url: "/nueva" }
          ]
        }
      }
    }
    assert_redirected_to configuraciones_path(seccion: "menu")

    get root_path
    assert_response :success
    assert_select "nav a[href='/nueva']", text: "Nueva sección"
    assert_select "nav a[href='/acerca']", count: 0
  end
end
