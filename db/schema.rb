# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_21_005140) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "chat_logs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "pregunta", null: false
    t.bigint "regla_id"
    t.text "respuesta"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["regla_id"], name: "index_chat_logs_on_regla_id"
    t.index ["user_id"], name: "index_chat_logs_on_user_id"
  end

  create_table "conceptos", force: :cascade do |t|
    t.string "categoria"
    t.datetime "created_at", null: false
    t.text "definicion", null: false
    t.integer "estado", default: 0, null: false
    t.string "fuente"
    t.string "sinonimos"
    t.bigint "tema_id", null: false
    t.string "termino", null: false
    t.datetime "updated_at", null: false
    t.index ["estado"], name: "index_conceptos_on_estado"
    t.index ["tema_id"], name: "index_conceptos_on_tema_id"
    t.index ["termino"], name: "index_conceptos_on_termino", unique: true
  end

  create_table "configuraciones", force: :cascade do |t|
    t.string "clave", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "valor", default: {}, null: false
    t.index ["clave"], name: "index_configuraciones_on_clave", unique: true
  end

  create_table "documentos", force: :cascade do |t|
    t.integer "anio"
    t.string "autores"
    t.datetime "created_at", null: false
    t.string "doi"
    t.integer "estado", default: 0, null: false
    t.text "referencia"
    t.text "resumen"
    t.integer "tipo", default: 0, null: false
    t.string "titulo", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["tipo"], name: "index_documentos_on_tipo"
    t.index ["titulo"], name: "index_documentos_on_titulo"
  end

  create_table "enlace_conceptos", force: :cascade do |t|
    t.bigint "concepto_id", null: false
    t.datetime "created_at", null: false
    t.integer "orden", default: 0
    t.string "titulo", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.index ["concepto_id", "orden"], name: "index_enlace_conceptos_on_concepto_id_and_orden"
    t.index ["concepto_id"], name: "index_enlace_conceptos_on_concepto_id"
  end

  create_table "enlace_sistema_gobiernos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "orden", default: 0
    t.bigint "sistema_gobierno_id", null: false
    t.string "titulo", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.index ["sistema_gobierno_id", "orden"], name: "idx_on_sistema_gobierno_id_orden_efb6e7eb13"
    t.index ["sistema_gobierno_id"], name: "index_enlace_sistema_gobiernos_on_sistema_gobierno_id"
  end

  create_table "enlaces", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "descripcion"
    t.integer "orden", default: 0, null: false
    t.bigint "seccion_id", null: false
    t.string "titulo", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.index ["seccion_id"], name: "index_enlaces_on_seccion_id"
  end

  create_table "indicadores", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "descripcion"
    t.string "metodo"
    t.string "nombre", null: false
    t.datetime "updated_at", null: false
    t.bigint "variable_id", null: false
    t.index ["variable_id"], name: "index_indicadores_on_variable_id"
  end

  create_table "paises", force: :cascade do |t|
    t.integer "continente", default: 0, null: false
    t.datetime "created_at", null: false
    t.text "descripcion"
    t.boolean "destacado", default: false, null: false
    t.string "nombre", null: false
    t.string "region"
    t.datetime "updated_at", null: false
    t.index ["nombre"], name: "index_paises_on_nombre", unique: true
  end

  create_table "particularidades", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "descripcion"
    t.bigint "sistema_id", null: false
    t.string "titulo", null: false
    t.datetime "updated_at", null: false
    t.index ["sistema_id"], name: "index_particularidades_on_sistema_id"
  end

  create_table "recursos_didacticos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "descripcion"
    t.integer "estado", default: 0, null: false
    t.string "referencia"
    t.integer "tipo", default: 0, null: false
    t.string "titulo", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["tipo"], name: "index_recursos_didacticos_on_tipo"
    t.index ["titulo"], name: "index_recursos_didacticos_on_titulo"
  end

  create_table "referencias", force: :cascade do |t|
    t.bigint "concepto_id", null: false
    t.datetime "created_at", null: false
    t.bigint "documento_id", null: false
    t.datetime "updated_at", null: false
    t.index ["concepto_id", "documento_id"], name: "index_referencias_on_concepto_id_and_documento_id", unique: true
    t.index ["concepto_id"], name: "index_referencias_on_concepto_id"
    t.index ["documento_id"], name: "index_referencias_on_documento_id"
  end

  create_table "reglas", force: :cascade do |t|
    t.boolean "activa", default: true, null: false
    t.datetime "created_at", null: false
    t.string "intent", null: false
    t.string "keywords", null: false
    t.text "respuesta"
    t.datetime "updated_at", null: false
    t.index ["intent"], name: "index_reglas_on_intent", unique: true
  end

  create_table "secciones", force: :cascade do |t|
    t.string "clave", null: false
    t.datetime "created_at", null: false
    t.text "cuerpo"
    t.string "titulo", null: false
    t.datetime "updated_at", null: false
    t.index ["clave"], name: "index_secciones_on_clave", unique: true
  end

  create_table "sistema_gobiernos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "descripcion"
    t.integer "estado", default: 1, null: false
    t.string "etapa", default: "otros_conceptos", null: false
    t.string "nombre", null: false
    t.integer "orden", default: 0
    t.datetime "updated_at", null: false
    t.index ["etapa"], name: "index_sistema_gobiernos_on_etapa"
  end

  create_table "sistemas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "descripcion"
    t.bigint "pais_id", null: false
    t.integer "tipo", null: false
    t.datetime "updated_at", null: false
    t.index ["pais_id", "tipo"], name: "index_sistemas_on_pais_id_and_tipo", unique: true
    t.index ["pais_id"], name: "index_sistemas_on_pais_id"
  end

  create_table "temas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "descripcion"
    t.string "nombre", null: false
    t.datetime "updated_at", null: false
    t.index ["nombre"], name: "index_temas_on_nombre", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "nombre"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "rol", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "variables", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "descripcion"
    t.string "nombre", null: false
    t.bigint "particularidad_id", null: false
    t.datetime "updated_at", null: false
    t.index ["particularidad_id"], name: "index_variables_on_particularidad_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "chat_logs", "reglas"
  add_foreign_key "chat_logs", "users"
  add_foreign_key "conceptos", "temas"
  add_foreign_key "enlace_conceptos", "conceptos"
  add_foreign_key "enlace_sistema_gobiernos", "sistema_gobiernos"
  add_foreign_key "enlaces", "secciones"
  add_foreign_key "indicadores", "variables"
  add_foreign_key "particularidades", "sistemas"
  add_foreign_key "referencias", "conceptos"
  add_foreign_key "referencias", "documentos"
  add_foreign_key "sistemas", "paises"
  add_foreign_key "variables", "particularidades"
end
