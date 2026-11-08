class CreateSecciones < ActiveRecord::Migration[8.1]
  def change
    create_table :secciones do |t|
      t.string :clave, null: false
      t.string :titulo, null: false
      t.text :cuerpo

      t.timestamps
    end
    add_index :secciones, :clave, unique: true
  end
end
