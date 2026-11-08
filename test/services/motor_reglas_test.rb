require "test_helper"

class MotorReglasTest < ActiveSupport::TestCase
  # Conjunto de prueba del Flujo.md §4 (12 preguntas)
  test "1. definición de concepto publicado" do
    r = MotorReglas.responder("¿Qué es el poder político?")
    assert r[:matched]
    assert_includes r[:respuesta], "Poder político"
    assert_includes r[:respuesta], "Capacidad de imponer"
  end

  test "2. definición con sinónimo de consulta" do
    r = MotorReglas.responder("¿Qué es la soberanía?")
    assert r[:matched]
    assert_includes r[:respuesta], "Soberanía"
  end

  test "3. consulta con la palabra definición" do
    r = MotorReglas.responder("definición de hegemonía")
    assert r[:matched]
    assert_includes r[:respuesta].downcase, "hegemonía"
  end

  test "4. documentos sobre un tema" do
    r = MotorReglas.responder("Documentos sobre Estado")
    assert_equal "documentos_tema", r[:regla].intent
    assert_includes r[:respuesta], "El Estado en la teoría política"
  end

  test "5. artículos relacionados" do
    r = MotorReglas.responder("¿Hay artículos sobre ciberseguridad?")
    assert r[:matched]
    assert_includes r[:respuesta], "Ciberseguridad"
  end

  test "6. sistema electoral de Cuba" do
    r = MotorReglas.responder("¿Cómo es el sistema electoral de Cuba?")
    assert_equal "sistema_pais", r[:regla].intent
    assert_includes r[:respuesta], "Voto libre"
  end

  test "7. sistema político de México" do
    r = MotorReglas.responder("Sistema político de México")
    assert_equal "sistema_pais", r[:regla].intent
    assert_includes r[:respuesta], "República federal"
  end

  test "8. saludo" do
    r = MotorReglas.responder("Hola")
    assert_equal "informacion_general", r[:regla].intent
  end

  test "9. agradecimiento" do
    r = MotorReglas.responder("Gracias")
    assert_equal "agradecimiento", r[:regla].intent
  end

  test "10. concepto inexistente devuelve no encontrado" do
    r = MotorReglas.responder("¿Qué es el concepto inexistente?")
    assert r[:matched]
    assert_includes r[:respuesta], "No encontré"
  end

  test "11. consulta sin sentido devuelve fallback" do
    r = MotorReglas.responder("jskdfj dfjh")
    assert_not r[:matched]
    assert_includes r[:respuesta], "No comprendí"
  end

  test "12. sistema constitucional de España" do
    r = MotorReglas.responder("¿Qué es el sistema constitucional de España?")
    assert_equal "sistema_pais", r[:regla].intent
    assert_includes r[:respuesta], "Constitución de 1978"
  end

  test "recursos didácticos citados (intent recursos_tic)" do
    r = MotorReglas.responder("¿Hay recursos sobre ciberseguridad?")
    assert_equal "recursos_tic", r[:regla].intent
    assert_includes r[:respuesta], "Ciberseguridad y ciudadanía digital"
  end

  test "no se citan recursos en borrador" do
    r = MotorReglas.responder("recursos actividad")
    assert_not_includes r[:respuesta], "Recurso sin publicar"
  end
end
