require "test_helper"

class ImportadorCsvTest < ActiveSupport::TestCase
  def archivo_csv(filas)
    Tempfile.new(["importacion", ".csv"]).tap do |f|
      f.write(filas.join("\n"))
      f.rewind
    end
  end

  test "conceptos: carga 100 filas con 5 inválidas y reporta las 5" do
    filas = ["termino;definicion;sinonimos;categoria;tema;fuente"]
    100.times do |i|
      if (i % 20).zero?
        filas << ";Definición #{i};;;;Tema #{i}"
      else
        filas << "Concepto #{i};Definición #{i};;;Tema #{i};Fuente"
      end
    end
    resumen = ImportadorCsv.conceptos(archivo_csv(filas))
    assert_equal 95, resumen[:cargados]
    assert_equal 5, resumen[:errores].size
    assert resumen[:errores].all? { |e| e[:fila].is_a?(Integer) }
    assert resumen[:errores].map { |e| e[:fila] }.uniq.size == 5
  end

  test "conceptos: separador por coma y encabezado sin BOM" do
    filas = ["termino,definicion,tema", "Legitimidad,Reconocimiento del poder,Teoría del Estado"]
    resumen = ImportadorCsv.conceptos(archivo_csv(filas))
    assert_equal 1, resumen[:cargados]
    assert Concepto.exists?(termino: "Legitimidad")
    assert Tema.exists?(nombre: "Teoría del Estado")
  end

  test "paises: crea país y sistemas por fila, reporta inválidas" do
    filas = ["pais;continente;region;descripcion;sistema_tipo;sistema_descripcion",
             "Argentina;america;Sudamérica;República federal.;politico;Presidencialismo.",
             "Argentina;america;Sudamérica;República federal.;electoral;Voto voluntario.",
             ";america;;;;politico;Sin nombre",
             "Perú;continente-invalido;;;;politico;Desc"]
    resumen = ImportadorCsv.paises(archivo_csv(filas))
    assert_equal 2, resumen[:cargados]
    assert_equal 2, resumen[:errores].size
    argentina = Pais.find_by(nombre: "Argentina")
    assert_equal 2, argentina.sistemas.count
  end
end
