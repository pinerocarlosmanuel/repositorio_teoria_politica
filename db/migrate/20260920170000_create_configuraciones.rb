class CreateConfiguraciones < ActiveRecord::Migration[8.1]
  def change
    create_table :configuraciones do |t|
      t.string :clave, null: false
      t.jsonb :valor, null: false, default: {}

      t.timestamps
    end
    add_index :configuraciones, :clave, unique: true
  end
end
