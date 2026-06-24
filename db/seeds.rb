# db/seeds.rb
require "json"

puts "🌱 Iniciando seed do CAMAAR..."

classes_data  = JSON.parse(File.read(Rails.root.join("classes.json")))
members_data  = JSON.parse(File.read(Rails.root.join("class_members.json")))

# ── Disciplinas ──────────────────────────────────────────────────────
classes_data.each do |item|
  Disciplina.find_or_create_by!(codigo: item["code"]) do |d|
    d.nome = item["name"]
  end
end
puts "  ✓ Disciplinas: #{Disciplina.count}"

# ── Docentes, Turmas e Discentes ─────────────────────────────────────
members_data.each do |turma_data|
  disciplina   = Disciplina.find_by!(codigo: turma_data["code"])
  depto_nome   = turma_data.dig("docente", "departamento") || "Sem Departamento"
  departamento = Departamento.find_or_create_by!(nome: depto_nome)

  doc_data    = turma_data["docente"]
  usuario_doc = Usuario.find_or_create_by!(login: doc_data["usuario"]) do |u|
    u.nome           = doc_data["nome"]
    u.email          = doc_data["email"]
    u.password       = "Mudar@2024"
    u.perfil         = 1 # :docente
    u.primeiro_acesso = true
  end
  docente = Docente.find_or_create_by!(usuario: usuario_doc) do |d|
    d.departamento = departamento
  end

  horario = classes_data.find { |c| c["code"] == turma_data["code"] }&.dig("class", "time")
  turma   = Turma.find_or_create_by!(codigo: turma_data["classCode"],
                                      semestre: turma_data["semester"],
                                      disciplina: disciplina) do |t|
    t.docente = docente
    t.horario = horario
  end

  turma_data["dicente"].each do |disc_data|
    usuario_disc = Usuario.find_or_create_by!(login: disc_data["usuario"]) do |u|
      u.nome           = disc_data["nome"]
      u.email          = disc_data["email"]
      u.password       = "Mudar@2024"
      u.perfil         = 0 # :discente
      u.primeiro_acesso = true
    end
    discente = Discente.find_or_create_by!(usuario: usuario_disc) do |d|
      d.matricula = disc_data["matricula"]
      d.curso     = disc_data["curso"]
    end
    Matricula.find_or_create_by!(discente: discente, turma: turma)
  end
end
puts "  ✓ Docentes: #{Docente.count}"
puts "  ✓ Discentes: #{Discente.count}"
puts "  ✓ Turmas: #{Turma.count}"
puts "  ✓ Matrículas: #{Matricula.count}"

# ── Admin Geral do Sistema ───────────────────────────────────────────
Usuario.find_or_create_by!(login: "admin") do |u|
  u.nome           = "Administrador"
  u.email          = "admin@cic.unb.br"
  u.password       = "Admin@2024"
  u.perfil         = 2 # :admin
  u.primeiro_acesso = false
end
puts "  ✓ Admin criado (admin / Admin@2024)"


# ── CORREÇÃO DE TESTES ANTERIORES (Issues #11, #12, #13) ──────────────

# Issue #13 — Login: usuários com senha já definida
user_discente = Usuario.find_or_create_by!(email: "discente@camaar.com") do |user|
  user.nome = "Discente Teste"
  user.login = "202400001"
  user.perfil = 0
  user.password = "123456"
  user.password_confirmation = "123456"
  user.primeiro_acesso = true
end
Discente.find_or_create_by!(usuario: user_discente) do |d|
  d.matricula = "202400001"
  d.curso     = "computação"
end

user_admin = Usuario.find_or_create_by!(email: "admin@camaar.com") do |user|
  user.nome = "Administrador"
  user.login = "000000001"
  user.perfil = 2
  user.password = "123456"
  user.password_confirmation = "123456"
  user.primeiro_acesso = false
end

# Issue #12 — Definição de senha: usuário importado sem senha
user_novo = Usuario.find_or_create_by!(email: "novo@camaar.com") do |user|
  user.nome = "Usuario Novo SIGAA"
  user.login = "202400099"
  user.perfil = 0
  user.password = "123456"
  user.primeiro_acesso = true
end
Discente.find_or_create_by!(usuario: user_novo) do |d|
  d.matricula = "202400099"
  d.curso     = "computação"
end

# Issue #11 — Gerenciamento por departamento
fabrica_depto = Departamento.find_or_create_by!(nome: "Fábrica de Software")
Admin.find_or_create_by!(usuario: user_admin, departamento: fabrica_depto)

# Garantindo chaves estrangeiras e relacionamentos válidos para as turmas de teste finais
prof_teste = Docente.first || Docente.create!(
  usuario: Usuario.find_or_create_by!(login: "prof_fallback", email: "fallback@unb.br", password: "Mudar@2024", perfil: 1),
  departamento: fabrica_depto
)

disc_es = Disciplina.find_or_create_by!(codigo: "FGA0001") { |d| d.nome = "Engenharia de Software" }
disc_ed = Disciplina.find_or_create_by!(codigo: "FGA0002") { |d| d.nome = "Estrutura de Dados" }

# Criando as turmas de teste amarradas às regras corretas (sem passar campos inexistentes)
Turma.find_or_create_by!(codigo: "TA", semestre: "2026.1", disciplina: disc_es, docente: prof_teste)
Turma.find_or_create_by!(codigo: "TB", semestre: "2026.1", disciplina: disc_ed, docente: prof_teste)

puts "\n✅ Seed concluído com sucesso!"
