require "test_helper"

class SeccionesEnlacesTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "visitante ve las páginas públicas de secciones" do
    get acerca_path
    assert_response :success
    assert_select "button.tab-btn", text: /Misión/
    assert_select "button.tab-btn", text: /Visión/
    assert_select "button.tab-btn", text: /Estrategia/
    assert_select "h1", /Misión/
    assert_select "a[href='https://spanishrevolutions.com']"

    get teoria_de_la_conspiracion_path
    assert_response :success
    assert_select "h1", /Teoría de la conspiración/
    assert_select "a[href='https://www.cia.gov/readingroom/']"
  end

  test "visitante no puede gestionar secciones ni enlaces" do
    get secciones_path
    assert_redirected_to root_path
    get enlaces_path
    assert_redirected_to root_path
    assert_no_difference("Seccion.count") do
      post secciones_path, params: { seccion: { clave: "nueva", titulo: "Nueva" } }
    end
    assert_no_difference("Enlace.count") do
      post enlaces_path, params: { enlace: { seccion_id: secciones(:teoria_conspiracion).id, titulo: "X", url: "https://x.example" } }
    end
  end

  test "editor no puede crear enlaces (solo admin)" do
    sign_in users(:editor)
    assert_no_difference("Enlace.count") do
      post enlaces_path, params: { enlace: { seccion_id: secciones(:teoria_conspiracion).id, titulo: "X", url: "https://x.example" } }
    end
    assert_redirected_to root_path
  end

  test "admin puede crear una sección" do
    sign_in users(:admin)
    assert_difference("Seccion.count", 1) do
      post secciones_path, params: { seccion: { clave: "institucional", titulo: "Institucional", cuerpo: "Texto." } }
    end
    assert_redirected_to seccion_path(Seccion.last)
  end

  test "admin puede crear un enlace" do
    sign_in users(:admin)
    assert_difference("Enlace.count", 1) do
      post enlaces_path, params: {
        enlace: { seccion_id: secciones(:teoria_conspiracion).id, titulo: "Willian", url: "https://example.com/willian", descripcion: "Videos", orden: 2 }
      }
    end
    assert_redirected_to enlace_path(Enlace.last)
  end

  test "admin puede actualizar y eliminar un enlace" do
    sign_in users(:admin)
    enlace = enlaces(:enlace_cia)

    get seccion_path(secciones(:teoria_conspiracion))
    assert_response :success

    get edit_seccion_path(secciones(:teoria_conspiracion))
    assert_response :success

    get edit_enlace_path(enlace)
    assert_response :success

    patch enlace_path(enlace), params: { enlace: { titulo: "CIA CREST" } }
    assert_redirected_to enlace_path(enlace)
    assert_equal "CIA CREST", enlace.reload.titulo

    assert_difference("Enlace.count", -1) { delete enlace_path(enlace) }
  end
end
