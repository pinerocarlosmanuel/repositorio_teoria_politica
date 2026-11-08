class CreateEnlaceConceptos < ActiveRecord::Migration[8.1]
  def change
    create_table :enlace_conceptos do |t|
      t.references :concepto, null: false, foreign_key: true
      t.string :titulo, null: false
      t.string :url, null: false
      t.integer :orden, default: 0

      t.timestamps
    end
    add_index :enlace_conceptos, [ :concepto_id, :orden ]
  end
end
