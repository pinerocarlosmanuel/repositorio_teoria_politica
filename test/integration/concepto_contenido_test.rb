require "test_helper"

class ConceptoContenidoTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "visitante ve el detalle del concepto con sus enlaces" do
    get concepto_path(conceptos(:poder))
    assert_response :success
    assert_select "a[href='#{enlace_conceptos(:poder_wikipedia).url}']", text: enlace_conceptos(:poder_wikipedia).titulo
  end

  test "visitante no puede añadir ni eliminar enlaces" do
    sign_out :user
    get new_concepto_path
    assert_redirected_to root_path
    assert_no_difference("EnlaceConcepto.count") do
      post concepto_enlace_conceptos_path(conceptos(:poder)), params: {
        enlace_concepto: { titulo: "Fuente", url: "https://example.com" }
      }
    end
    assert_redirected_to root_path
  end

  test "editor puede añadir un enlace a un concepto" do
    sign_in users(:editor)
    assert_difference("EnlaceConcepto.count", 1) do
      post concepto_enlace_conceptos_path(conceptos(:poder)), params: {
        enlace_concepto: { titulo: "Origen etimológico", url: "https://etimologias.com/poder" }
      }
    end
    assert_redirected_to concepto_path(conceptos(:poder))
    assert_equal "Origen etimológico", EnlaceConcepto.last.titulo
  end

  test "editor puede eliminar un enlace de un concepto" do
    sign_in users(:editor)
    assert_difference("EnlaceConcepto.count", -1) do
      delete enlace_concepto_path(enlace_conceptos(:poder_wikipedia))
    end
    assert_redirected_to concepto_path(conceptos(:poder))
  end

  test "el enlace debe ser una URL válida (http/https)" do
    sign_in users(:editor)
    assert_no_difference("EnlaceConcepto.count") do
      post concepto_enlace_conceptos_path(conceptos(:poder)), params: {
        enlace_concepto: { titulo: "Roto", url: "www.sin-protocolo.com" }
      }
    end
  end

  test "editor puede adjuntar un archivo al concepto desde el CRUD" do
    sign_in users(:editor)
    conceptos(:soberania).archivo.attach(io: StringIO.new("contenido"), filename: "soberania.pdf", content_type: "application/pdf")
    conceptos(:soberania).save!
    get descargar_concepto_path(conceptos(:soberania))
    assert_response :redirect
    assert_enqueued_emails 0
  end
end
