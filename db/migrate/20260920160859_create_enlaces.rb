class CreateEnlaces < ActiveRecord::Migration[8.1]
  def change
    create_table :enlaces do |t|
      t.references :seccion, null: false, foreign_key: { to_table: :secciones }
      t.string :titulo, null: false
      t.string :url, null: false
      t.text :descripcion
      t.integer :orden, default: 0, null: false

      t.timestamps
    end
  end
end
