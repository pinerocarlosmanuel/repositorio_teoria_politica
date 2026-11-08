class CreateSistemasGobierno < ActiveRecord::Migration[8.1]
  def change
    create_table :sistema_gobiernos do |t|
      t.string :nombre, null: false
      t.string :etapa, null: false, default: "otros_conceptos"
      t.text :descripcion
      t.integer :orden, default: 0
      t.integer :estado, default: 1, null: false

      t.timestamps
    end
    add_index :sistema_gobiernos, :etapa
  end
end
