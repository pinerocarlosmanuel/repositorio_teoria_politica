require "test_helper"

class DocumentosUploadTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  PDF_FIXTURE = Rails.root.join("test/fixtures/files/documento_prueba.pdf")
  PNG_FIXTURE = Rails.root.join("test/fixtures/files/imagen_invalida.png")

  test "editor sube un documento con archivo PDF" do
    sign_in users(:editor)
    assert_difference("Documento.count", 1) do
      post documentos_path, params: {
        documento: {
          titulo: "Documento con adjunto", autores: "Autor de Prueba", anio: 2026,
          estado: "publicado", archivo: fixture_file_upload(PDF_FIXTURE, "application/pdf")
        }
      }
    end
    d = Documento.last
    assert d.archivo.attached?
    assert_equal "documento_prueba.pdf", d.archivo.filename.to_s
    assert_redirected_to documento_path(d)
  end

  test "admin también puede crear documentos (acceso al alta visible)" do
    sign_in users(:admin)
    assert_difference("Documento.count", 1) do
      post documentos_path, params: { documento: { titulo: "Doc creado por admin", estado: "publicado" } }
    end
  end

  test "tipo de archivo no permitido es rechazado con mensaje en español" do
    sign_in users(:editor)
    assert_no_difference("Documento.count") do
      post documentos_path, params: {
        documento: {
          titulo: "Imagen", estado: "publicado",
          archivo: fixture_file_upload(PNG_FIXTURE, "image/png")
        }
      }
    end
    assert_response :unprocessable_content
    assert_select ".alert-danger", /debe ser PDF/
  end

  test "visitante descarga un documento publicado" do
    d = documentos(:ciberseguridad)
    d.archivo.attach(io: File.open(PDF_FIXTURE), filename: "documento_prueba.pdf", content_type: "application/pdf")
    get descargar_documento_path(d)
    assert_redirected_to rails_blob_path(d.archivo, disposition: "attachment")
  end

  test "visitante no descarga un documento borrador" do
    d = documentos(:borrador_doc)
    d.archivo.attach(io: File.open(PDF_FIXTURE), filename: "documento_prueba.pdf", content_type: "application/pdf")
    get descargar_documento_path(d)
    assert_redirected_to root_path
  end

  test "salir de sesión por POST no da error" do
    sign_in users(:admin)
    delete destroy_user_session_path
    assert_redirected_to root_path
  end
end
