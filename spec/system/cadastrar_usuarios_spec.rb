require 'rails_helper'


RSpec.describe "Cadastrar usuário com dados válidos", type: :system do
  before do
    # has_firefox = system('which firefox > /dev/null 2>&1 || where firefox > /dev/null 2>&1')
    driven_by(:rack_test)
    # driven_by(:selenium, using: has_firefox ? :headless_firefox : :headless_chrome)

    @admin = User.create!(
      nome: "Administrador",
      email: "admin@camaar.com",
      matricula: "000000001",
      perfil: "Administrador",
      password: "123456"
    )
  end

  it "logar no perfil de Administrador" do
  visit '/login'

  fill_in 'E-mail ou matrícula', with: @admin.email
  fill_in 'Senha', with: @admin.password

  click_button 'Entrar'

  visit '/admin'

  expect(page).to have_current_path('/admin')
  end

  it "Acessar a opção de Gerenciamento" do
    visit '/login'

    fill_in 'E-mail ou matrícula', with: @admin.email
    fill_in 'Senha', with: @admin.password

    click_button 'Entrar'
    visit '/admin'

    expect(page).to have_link("Gerenciamento")
    click_link 'Gerenciamento'
    expect(page).to have_content("Painel de Gerenciamento")
  end
end
