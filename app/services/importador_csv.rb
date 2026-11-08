require "csv"

class ImportadorCsv
  def self.conceptos(archivo)
    resumen = { cargados: 0, errores: [] }
    filas(archivo).each do |fila, n|
      c = Concepto.new(
        termino: fila["termino"]&.strip,
        definicion: fila["definicion"]&.strip,
        sinonimos: fila["sinonimos"]&.strip,
        categoria: fila["categoria"]&.strip,
        fuente: fila["fuente"]&.strip,
        estado: :borrador
      )
      tema_nombre = fila["tema"]&.strip
      c.tema = Tema.find_or_create_by(nombre: tema_nombre) if tema_nombre.present?
      registrar(resumen, n, c)
    end
    resumen
  end

  def self.paises(archivo)
    resumen = { cargados: 0, errores: [] }
    filas(archivo).each do |fila, n|
      pais = Pais.find_or_create_by(nombre: fila["pais"]&.strip) do |p|
        p.continente = fila["continente"]&.strip if Pais.continentes.key?(fila["continente"]&.strip)
        p.region = fila["region"]&.strip
        p.descripcion = fila["descripcion"]&.strip
      end
      sistema = Sistema.new(
        tipo: fila["sistema_tipo"]&.strip,
        descripcion: fila["sistema_descripcion"]&.strip,
        pais: pais
      )
      registrar(resumen, n, sistema)
    end
    resumen
  end

  def self.filas(archivo)
    contenido = File.read(archivo.path, encoding: "bom|utf-8")
    sep = contenido.lines.first.to_s.include?(";") ? ";" : ","
    CSV.parse(contenido, headers: true, col_sep: sep).map.with_index do |fila, i|
      [fila, i + 2]
    end
  end

  def self.registrar(resumen, n, modelo)
    if modelo.save
      resumen[:cargados] += 1
    else
      resumen[:errores] << { fila: n, error: modelo.errors.full_messages.join(", ") }
    end
  end
end
