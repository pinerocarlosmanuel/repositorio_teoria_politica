require "test_helper"

class ConceptoTest < ActiveSupport::TestCase
  test "validaciones obligatorias" do
    concepto = Concepto.new
    assert_not concepto.valid?
    assert concepto.errors[:termino].any?
    assert concepto.errors[:definicion].any?
  end

  test "término único" do
    duplicado = Concepto.new(termino: "Poder político", definicion: "x", tema: temas(:estado))
    assert_not duplicado.valid?
  end

  test "solo publicados visibles en scope" do
    assert_includes Concepto.publicados, conceptos(:poder)
    assert_not_includes Concepto.publicados, conceptos(:borrador)
  end

  test "búsqueda full-text encuentra por término" do
    assert_includes Concepto.busqueda("poder"), conceptos(:poder)
  end
end
