class CreateEnlaceSistemaGobiernos < ActiveRecord::Migration[8.1]
  def change
    create_table :enlace_sistema_gobiernos do |t|
      t.references :sistema_gobierno, null: false, foreign_key: true
      t.string :titulo, null: false
      t.string :url, null: false
      t.integer :orden, default: 0

      t.timestamps
    end
    add_index :enlace_sistema_gobiernos, [ :sistema_gobierno_id, :orden ]
  end
end
