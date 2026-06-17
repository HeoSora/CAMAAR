# Issue #13 — Login: usuários com senha já definida
User.find_or_create_by!(email: "discente@camaar.com") do |user|
  user.nome = "Discente Teste"
  user.matricula = "202400001"
  user.perfil = "Discente"
  user.password = "123456"
  user.password_confirmation = "123456"
  user.primeiro_acesso = false
end

User.find_or_create_by!(email: "admin@camaar.com") do |user|
  user.nome = "Administrador Teste"
  user.matricula = "000000001"
  user.perfil = "Administrador"
  user.password = "123456"
  user.password_confirmation = "123456"
  user.primeiro_acesso = false
end

# Issue #12 — Definição de senha: usuário importado sem senha
User.find_or_create_by!(email: "novo@camaar.com") do |user|
  user.nome = "Usuario Novo SIGAA"
  user.matricula = "202400099"
  user.perfil = "Discente"
  user.primeiro_acesso = true
end

# Issue #11 — Gerenciamento por departamento
departamento = Departamento.find_or_create_by!(nome: "Fábrica de Software")

admin_user = User.find_by!(email: "admin@camaar.com")
Admin.find_or_create_by!(user: admin_user, departamento: departamento)

Turma.find_or_create_by!(codigo: "FGA0001", departamento: departamento) do |turma|
  turma.nome = "Engenharia de Software"
end

Turma.find_or_create_by!(codigo: "FGA0002", departamento: departamento) do |turma|
  turma.nome = "Estrutura de Dados"
end
