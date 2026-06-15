
# Cenário: [Feliz] Cadastrar usuário com dados válidos
Dado('que eu estou logado no sistema com o perfil de {string}') do |string|
  @user_perfil = string.capitalize

  User.find_or_create_by!(email: "admin@camaar.com") do |user|
    user.nome = @user_perfil
    user.matricula = "000000001"
    user.perfil = @user_perfil
    user.password = "123456"
    user.password_confirmation = "123456"
  end

  visit '/'

  fill_in 'E-mail ou matrícula', with: 'admin@camaar.com'
  fill_in 'Senha', with: '123456'

  click_button 'Entrar'

  expect(page).to have_current_path('/admin')
  # expect(page).to have_content('Bem-vindo, #{string}')
end


Dado('que eu acesso a opção de {string} no menu lateral') do |string|
  @opcao_menu = string
  expect(page).to have_link(@opcao_menu) # mudar para have_link ou have_button dependendo do tipo de elemento
  click_link @opcao_menu
end


Quando('eu clico em {string}') do |string|
  @import_usuarios = 'Importar Dados'
  expect(page).to have_content(@import_usuarios) # mudar para have_link ou have_button dependendo do tipo de elemento
  
end

Quando('seleciono um arquivo JSON contendo os dados de novos usuários do SIGAA') do
  pending # Write code here that turns the phrase above into concrete actions
end

=begin
Quando('os dados estão válidos no arquivo importado') do
  pending # Write code here that turns the phrase above into concrete actions
end

Então('o sistema deve processar o arquivo e criar solicitações de definição de senha para cada usuário novo') do
  pending # Write code here that turns the phrase above into concrete actions
end

Então('os usuários devem receber um e-mail com um link para definir suas senhas') do
  pending # Write code here that turns the phrase above into concrete actions
end


# Cenário: [Feliz] Usuário permanece pendente enquanto não define a senha
Dado('que um usuário foi cadastrado com sucesso no sistema e recebeu um e-mail para definir a senha') do
  pending # Write code here that turns the phrase above into concrete actions
end

Dado('o usuário ainda não definiu sua senha') do
  pending # Write code here that turns the phrase above into concrete actions
end

Então('o sistema deve manter o status do usuário como {string}') do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

Então('o usuário não deve ter acesso ao sistema até que a senha seja definida') do
  pending # Write code here that turns the phrase above into concrete actions
end

# Cenário: [Feliz] Usuário define a senha e é ativado
Dado('o usuário definiu sua senha') do
  pending # Write code here that turns the phrase above into concrete actions
end

Então('o sistema deve atualizar o status do usuário para {string}') do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

Então('o usuário deve conseguir acessar o sistema com suas credenciais') do
  pending # Write code here that turns the phrase above into concrete actions
end


# Cenário: [Triste] Tentar cadastrar usuário já existente
Dado('que estou logado no sistema com o perfil de {string}') do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

Quando('seleciono um arquivo JSON contendo os dados de novos usuários') do
  pending # Write code here that turns the phrase above into concrete actions
end

Quando('os dados estão inválidos no arquivo importado') do
  pending # Write code here that turns the phrase above into concrete actions
end

Então('o sistema deve exibir uma mensagem de erro {string}') do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

Então('o sistema não deve criar solicitações de definição de senha para os usuários') do
  pending # Write code here that turns the phrase above into concrete actions
end


# Cenário: [Triste] Tentar cadastrar usuário já existente
Quando('os dados estão válidos mas correspondem a usuários já existentes no sistema') do
  pending # Write code here that turns the phrase above into concrete actions
end

Então('o sistema deve exibir uma mensagem de aviso {string}') do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

Então('o sistema não deve criar solicitações de definição de senha para os usuários duplicados') do
  pending # Write code here that turns the phrase above into concrete actions
end

=end
