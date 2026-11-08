require "test_helper"

class SeccionTest < ActiveSupport::TestCase
  test "validaciones obligatorias" do
    seccion = Seccion.new
    assert_not seccion.valid?
    assert seccion.errors[:clave].any?
    assert seccion.errors[:titulo].any?
  end

  test "clave única" do
    duplicada = Seccion.new(clave: "mision", titulo: "Duplicada")
    assert_not duplicada.valid?
  end

  test "por_clave encuentra la sección pública" do
    assert_equal secciones(:mision), Seccion.por_clave("mision")
  end

  test "enlaces_ordenados los ordena por orden y título" do
    seccion = secciones(:teoria_conspiracion)
    seccion.enlaces.create!(titulo: "B", url: "https://b.example", orden: 1)
    seccion.enlaces.create!(titulo: "A", url: "https://a.example", orden: 0)

    assert_equal [ "A", "Documentos desclasificados de la CIA", "B" ],
                 seccion.enlaces_ordenados.map(&:titulo)
  end
end
