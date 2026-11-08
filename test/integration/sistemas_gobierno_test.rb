require "test_helper"

class SistemasGobiernoTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "visitante ve el catálogo público de sistemas de gobierno" do
    get sistemas_path
    assert_response :success
    assert_select "h1", "Sistemas de gobierno a lo largo de la historia"
    %w[Sociedad primitiva Esclavismo Feudalismo Absolutismo Comunismo].each do |etiqueta|
      assert_select "h2", /#{Regexp.escape(etiqueta)}/
    end
    assert_select "div", /Tecno-oligarquía/
    assert_select "div", /Monarquía esclavista/
    assert_select "div", /Capitalismo tardío/
  end

  test "el menú enlaza Sistemas al catálogo /sistemas" do
    get root_path
    assert_response :success
    assert_select "nav a[href='/sistemas']", text: "Sistemas"
  end

  test "visitante no puede crear ni editar sistemas de gobierno" do
    get new_sistemas_gobierno_path
    assert_redirected_to root_path
    assert_no_difference("SistemaGobierno.count") do
      post sistemas_gobierno_index_path, params: {
        sistema_gobierno: { nombre: "Porrismo", etapa: "otros_conceptos" }
      }
    end
    assert_redirected_to root_path
  end

  test "editor puede crear y editar un sistema de gobierno" do
    sign_in users(:editor)
    assert_difference("SistemaGobierno.count", 1) do
      post sistemas_gobierno_index_path, params: {
        sistema_gobierno: {
          nombre: "Confederación", etapa: "otros_conceptos", orden: 14,
          descripcion: "Unión de estados que conservan su autonomía.", estado: "publicado"
        }
      }
    end
    s = SistemaGobierno.last
    assert_equal "Confederación", s.nombre
    patch sistemas_gobierno_path(s), params: {
      sistema_gobierno: { orden: 15 }
    }
    assert_redirected_to sistemas_gobierno_path(s)
    assert_equal 15, s.reload.orden
  end

  test "el catálogo excluye borradores del público" do
    borrador = SistemaGobierno.create!(nombre: "Fantasia no publicada", etapa: "otros_conceptos", estado: :borrador)
    get sistemas_path
    assert_response :success
    assert_select "div", text: /Fantasia no publicada/, count: 0
  end

  test "visitante ve el detalle con imagen y enlaces del sistema" do
    sg = sistema_gobiernos(:comunismo_primitivo)
    sg.imagen.attach(io: File.open(Rails.root.join("public/mes_logo.jpeg")), filename: "logo.png", content_type: "image/png")
    get sistemas_gobierno_path(sg)
    assert_response :success
    assert_select "img.img-fluid", count: 1
    assert_select "a[href='#{enlace_sistema_gobiernos(:comunismo_articulo).url}']", text: enlace_sistema_gobiernos(:comunismo_articulo).titulo
  end

  test "editor puede adjuntar una imagen JPEG desde el CRUD" do
    sign_in users(:editor)
    sg = sistema_gobiernos(:jefatura_tribal)
    patch sistemas_gobierno_path(sg), params: {
      sistema_gobierno: {
        imagen: Rack::Test::UploadedFile.new(Rails.root.join("public/mes_logo.jpeg"), "image/jpeg")
      }
    }
    assert_redirected_to sistemas_gobierno_path(sg)
    assert sg.reload.imagen.attached?
  end

  test "no se aceptan imágenes de tipo no permitido" do
    sign_in users(:editor)
    sg = sistema_gobiernos(:jefatura_tribal)
    patch sistemas_gobierno_path(sg), params: {
      sistema_gobierno: {
        imagen: fixture_file_upload("documento_prueba.pdf", "application/pdf")
      }
    }
    assert_response :unprocessable_content
    assert_not sg.reload.imagen.attached?
    assert_match(/debe ser PNG, JPEG o SVG/, response.body)
  end

  test "editor puede añadir un enlace a un sistema de gobierno" do
    sign_in users(:editor)
    sg = sistema_gobiernos(:jefatura_tribal)
    assert_difference("EnlaceSistemaGobierno.count", 1) do
      post sistemas_gobierno_enlace_sistema_gobiernos_path(sg), params: {
        enlace_sistema_gobierno: { titulo: "Estudios sobre la jefatura", url: "https://example.com/jefatura" }
      }
    end
    assert_redirected_to sistemas_gobierno_path(sg)
    assert_equal "Estudios sobre la jefatura", EnlaceSistemaGobierno.last.titulo
  end

  test "visitante no puede añadir enlaces a un sistema de gobierno" do
    sg = sistema_gobiernos(:jefatura_tribal)
    assert_no_difference("EnlaceSistemaGobierno.count") do
      post sistemas_gobierno_enlace_sistema_gobiernos_path(sg), params: {
        enlace_sistema_gobierno: { titulo: "Privado", url: "https://example.com" }
      }
    end
    assert_redirected_to root_path
  end
end
