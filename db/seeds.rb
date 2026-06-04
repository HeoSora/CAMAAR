# db/seeds.rb
require 'json'
require 'bcrypt'

puts "🌱 Iniciando seed do CAMAAR..."

# ─── DISCIPLINAS e TURMAS ───────────────────────────────────────────
classes_data = JSON.parse(File.read(Rails.root.join("classes.json")))
classes_data.each do |item|
  disciplina = Disciplina.find_or_create_by!(codigo: item["code"]) do |d|
    d.nome = item["name"]
  end
  puts "  ✓ Disciplina: #{disciplina.nome}"
end

# ─── DOCENTE e DISCENTES ─────────────────────────────────────────────
members_data = JSON.parse(File.read(Rails.root.join("class_members.json")))

members_data.each do |turma_data|
  disciplina = Disciplina.find_by!(codigo: turma_data["code"])

  # Departamento
  depto_nome = turma_data.dig("docente", "departamento") || "Sem Departamento"
  departamento = Departamento.find_or_create_by!(nome: depto_nome)

  # Docente
  docente_data = turma_data["docente"]
  usuario_doc = Usuario.find_or_create_by!(login: docente_data["usuario"]) do |u|
    u.nome          = docente_data["nome"].titleize
    u.email         = docente_data["email"]
    u.password      = "Mudar@2024"
    u.perfil        = :docente
    u.primeiro_acesso = true
  end

  docente = Docente.find_or_create_by!(usuario: usuario_doc) do |d|
    d.departamento = departamento
  end
  puts "  ✓ Docente: #{docente.nome}"

  # Turma
  turma = Turma.find_or_create_by!(
    codigo:    turma_data["classCode"],
    semestre:  turma_data["semester"],
    disciplina: disciplina
  ) do |t|
    t.docente = docente
    t.horario = classes_data.find { |c| c["code"] == turma_data["code"] }&.dig("class", "time")
  end
  puts "  ✓ Turma: #{turma.nome_completo}"

  # Discentes
  turma_data["dicente"].each do |disc_data|
    usuario_disc = Usuario.find_or_create_by!(login: disc_data["usuario"]) do |u|
      u.nome          = disc_data["nome"].titleize
      u.email         = disc_data["email"]
      u.password      = "Mudar@2024"
      u.perfil        = :discente
      u.primeiro_acesso = true
    end

    discente = Discente.find_or_create_by!(usuario: usuario_disc) do |d|
      d.matricula = disc_data["matricula"]
      d.curso     = disc_data["curso"]
    end

    Matricula.find_or_create_by!(discente: discente, turma: turma)
  end
  puts "  ✓ #{turma_data["dicente"].count} discentes matriculados em #{turma.codigo}"
end

# ─── ADMIN ───────────────────────────────────────────────────────────
admin = Usuario.find_or_create_by!(login: "admin") do |u|
  u.nome          = "Administrador CAMAAR"
  u.email         = "admin@cic.unb.br"
  u.password      = "Admin@2024"
  u.perfil        = :admin
  u.primeiro_acesso = false
end
puts "  ✓ Admin: #{admin.email} / senha: Admin@2024"

puts "\n✅ Seed concluído!"
puts "   Usuários: #{Usuario.count}"
puts "   Docentes: #{Docente.count}"
puts "   Discentes: #{Discente.count}"
puts "   Turmas: #{Turma.count}"
puts "   Matrículas: #{Matricula.count}"
puts "\n⚠️  Todos os usuários devem mudar a senha no primeiro acesso."
