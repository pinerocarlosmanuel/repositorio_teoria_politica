class CreateRepositoryTables < ActiveRecord::Migration[8.1]
  def change
    # M1 - Temas y Conceptos
    create_table :temas do |t|
      t.string :nombre, null: false
      t.text :descripcion

      t.timestamps
    end
    add_index :temas, :nombre, unique: true

    create_table :conceptos do |t|
      t.string :termino, null: false
      t.text :definicion, null: false
      t.string :sinonimos
      t.string :categoria
      t.integer :estado, null: false, default: 0
      t.string :fuente
      t.references :tema, null: false, foreign_key: true

      t.timestamps
    end
    add_index :conceptos, :termino, unique: true
    add_index :conceptos, :estado

    # M2 - Documentos y Referencias
    create_table :documentos do |t|
      t.string :titulo, null: false
      t.string :autores
      t.integer :anio
      t.integer :tipo, null: false, default: 0
      t.text :resumen
      t.text :referencia
      t.string :doi
      t.string :url
      t.integer :estado, null: false, default: 0

      t.timestamps
    end
    add_index :documentos, :titulo
    add_index :documentos, :tipo

    create_table :referencias do |t|
      t.references :concepto, null: false, foreign_key: true
      t.references :documento, null: false, foreign_key: true

      t.timestamps
    end
    add_index :referencias, %i[concepto_id documento_id], unique: true

    # M3 - Países, Sistemas, Particularidades, Variables, Indicadores
    create_table :paises do |t|
      t.string :nombre, null: false
      t.integer :continente, null: false, default: 0
      t.string :region
      t.text :descripcion
      t.boolean :destacado, null: false, default: false

      t.timestamps
    end
    add_index :paises, :nombre, unique: true

    create_table :sistemas do |t|
      t.integer :tipo, null: false
      t.text :descripcion
      t.references :pais, null: false, foreign_key: true

      t.timestamps
    end
    add_index :sistemas, %i[pais_id tipo], unique: true

    create_table :particularidades do |t|
      t.string :titulo, null: false
      t.text :descripcion
      t.references :sistema, null: false, foreign_key: true

      t.timestamps
    end

    create_table :variables do |t|
      t.string :nombre, null: false
      t.text :descripcion
      t.references :particularidad, null: false, foreign_key: true

      t.timestamps
    end

    create_table :indicadores do |t|
      t.string :nombre, null: false
      t.text :descripcion
      t.string :metodo
      t.references :variable, null: false, foreign_key: true

      t.timestamps
    end

    # M4 - Reglas del chatbot y ChatLogs
    create_table :reglas do |t|
      t.string :intent, null: false
      t.string :keywords, null: false
      t.text :respuesta
      t.boolean :activa, null: false, default: true

      t.timestamps
    end
    add_index :reglas, :intent, unique: true

    create_table :chat_logs do |t|
      t.string :pregunta, null: false
      t.text :respuesta
      t.references :user, null: true, foreign_key: true
      t.references :regla, null: true, foreign_key: true

      t.timestamps
    end

    # M5 - Recursos didácticos TIC/TEP/TAC/IA
    create_table :recursos_didacticos do |t|
      t.string :titulo, null: false
      t.integer :tipo, null: false, default: 0
      t.text :descripcion
      t.string :url
      t.string :referencia
      t.integer :estado, null: false, default: 0

      t.timestamps
    end
    add_index :recursos_didacticos, :tipo
    add_index :recursos_didacticos, :titulo
  end
end
