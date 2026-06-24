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

ActiveRecord::Schema[8.1].define(version: 2026_06_16_231812) do
  create_table "admins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "departamento_id", null: false
    t.datetime "updated_at", null: false
    t.integer "usuario_id", null: false
    t.index ["departamento_id"], name: "index_admins_on_departamento_id"
    t.index ["usuario_id", "departamento_id"], name: "index_admins_on_usuario_id_and_departamento_id", unique: true
    t.index ["usuario_id"], name: "index_admins_on_usuario_id"
  end

  create_table "departamentos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "nome", null: false
    t.datetime "updated_at", null: false
    t.index ["nome"], name: "index_departamentos_on_nome", unique: true
  end

  create_table "discentes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "curso"
    t.string "email"
    t.string "formacao"
    t.string "matricula"
    t.string "nome"
    t.string "ocupacao"
    t.integer "turma_id", null: false
    t.datetime "updated_at", null: false
    t.string "usuario"
    t.index ["turma_id"], name: "index_discentes_on_turma_id"
  end

  create_table "disciplinas", force: :cascade do |t|
    t.string "codigo", null: false
    t.datetime "created_at", null: false
    t.string "nome", null: false
    t.datetime "updated_at", null: false
    t.index ["codigo"], name: "index_disciplinas_on_codigo", unique: true
  end

  create_table "docentes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "departamento"
    t.string "email"
    t.string "formacao"
    t.string "nome"
    t.string "ocupacao"
    t.integer "turma_id", null: false
    t.datetime "updated_at", null: false
    t.string "usuario"
    t.index ["turma_id"], name: "index_docentes_on_turma_id"
  end

  create_table "envio_formularios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "discente_id", null: false
    t.datetime "enviado_em"
    t.integer "formulario_id", null: false
    t.datetime "updated_at", null: false
    t.index ["discente_id"], name: "index_envio_formularios_on_discente_id"
    t.index ["formulario_id", "discente_id"], name: "index_envio_formularios_on_formulario_id_and_discente_id", unique: true
    t.index ["formulario_id"], name: "index_envio_formularios_on_formulario_id"
  end

  create_table "formularios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "prazo"
    t.integer "template_id", null: false
    t.string "titulo", null: false
    t.integer "turma_id", null: false
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_formularios_on_template_id"
    t.index ["turma_id"], name: "index_formularios_on_turma_id"
  end

  create_table "matriculas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "discente_id", null: false
    t.integer "turma_id", null: false
    t.datetime "updated_at", null: false
    t.index ["discente_id", "turma_id"], name: "index_matriculas_on_discente_id_and_turma_id", unique: true
    t.index ["discente_id"], name: "index_matriculas_on_discente_id"
    t.index ["turma_id"], name: "index_matriculas_on_turma_id"
  end

  create_table "opcao_questoes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "questao_template_id", null: false
    t.string "texto", null: false
    t.datetime "updated_at", null: false
    t.index ["questao_template_id"], name: "index_opcao_questoes_on_questao_template_id"
  end

  create_table "questao_templates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "enunciado", null: false
    t.integer "template_id", null: false
    t.integer "tipo", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_questao_templates_on_template_id"
  end

  create_table "questoes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "enunciado", null: false
    t.integer "formulario_id", null: false
    t.integer "questao_template_id", null: false
    t.integer "tipo", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["formulario_id"], name: "index_questoes_on_formulario_id"
    t.index ["questao_template_id"], name: "index_questoes_on_questao_template_id"
  end

  create_table "respostas", force: :cascade do |t|
    t.text "conteudo", null: false
    t.datetime "created_at", null: false
    t.integer "envio_formulario_id", null: false
    t.integer "questao_id", null: false
    t.datetime "updated_at", null: false
    t.index ["envio_formulario_id"], name: "index_respostas_on_envio_formulario_id"
    t.index ["questao_id"], name: "index_respostas_on_questao_id"
  end

  create_table "templates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "nome", null: false
    t.string "semestre", null: false
    t.datetime "updated_at", null: false
    t.integer "usuario_id", null: false
    t.index ["usuario_id"], name: "index_templates_on_usuario_id"
  end

  create_table "turmas", force: :cascade do |t|
    t.string "codigo", null: false
    t.datetime "created_at", null: false
    t.integer "departamento_id", null: false
    t.string "nome", null: false
    t.string "semestre"
    t.string "turma"
    t.datetime "updated_at", null: false
    t.index ["departamento_id"], name: "index_turmas_on_departamento_id"
  end

  create_table "usuarios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "login", null: false
    t.string "nome", null: false
    t.string "password_digest"
    t.integer "perfil", default: 0, null: false
    t.boolean "primeiro_acesso", default: true, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_usuarios_on_email", unique: true
    t.index ["login"], name: "index_usuarios_on_login", unique: true
  end

  add_foreign_key "admins", "departamentos"
  add_foreign_key "admins", "usuarios"
  add_foreign_key "discentes", "turmas"
  add_foreign_key "docentes", "turmas"
  add_foreign_key "envio_formularios", "discentes"
  add_foreign_key "envio_formularios", "formularios"
  add_foreign_key "formularios", "templates"
  add_foreign_key "formularios", "turmas"
  add_foreign_key "matriculas", "discentes"
  add_foreign_key "matriculas", "turmas"
  add_foreign_key "opcao_questoes", "questao_templates"
  add_foreign_key "questao_templates", "templates"
  add_foreign_key "questoes", "formularios"
  add_foreign_key "questoes", "questao_templates"
  add_foreign_key "respostas", "envio_formularios"
  add_foreign_key "respostas", "questaos"
  add_foreign_key "templates", "usuarios"
  add_foreign_key "turmas", "departamentos"
end
