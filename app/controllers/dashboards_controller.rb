require "json"

class DashboardsController < ApplicationController
  before_action :require_login


  layout "admin_layout", only: [ :admin, :admin_gerenciamento, :admin_avaliacao ]

  # tela de admin
  def admin
  end

  # tela de gerenciamento
  def admin_gerenciamento
    @turmas    = Turma.all
    @discentes = Discente.all
    @docentes  = Docente.all
  end

  # importação do json
  def importar_json
    file = params["json"].tempfile.path
    file_path = File.read(file)

    data_hash = JSON.parse(file_path)

    data_hash.each do |turma_dados|
      codigo = turma_dados["code"]
      semestre = turma_dados["semester"]
      turma = turma_dados["classCode"]

      refer_turma = Turma.find_or_create_by!(codigo: codigo, turma: turma, semestre: semestre)

      if turma_dados["dicente"].is_a?(Array)

        turma_dados["dicente"].each do |usuarios|
          nome = usuarios["nome"].downcase
          curso = usuarios["curso"].downcase
          matricula = usuarios["matricula"]
          usuario = usuarios["usuario"]
          formacao = usuarios["formacao"].downcase
          ocupacao = usuarios["ocupacao"].downcase
          email = usuarios["email"].downcase

          Discente.find_or_create_by!(nome: nome, curso: curso, matricula: matricula,
          usuario: usuario, formacao: formacao, ocupacao: ocupacao,
          email: email, turma: refer_turma)

          User.find_or_create_by!(nome: nome, matricula: matricula, perfil: "Discente", password: 123456, password_confirmation: 123456)
        end
      end


      if turma_dados["docente"].is_a?(Array)
        turma_dados["docente"].each do |usuarios|
          nome = usuarios["nome"].downcase
          departamento = usuarios["departamento"].downcase
          usuario = usuarios["usuario"]
          formacao = usuarios["formacao"].downcase
          ocupacao = usuarios["ocupacao"].downcase
          email = usuarios["email"].downcase



          Docente.find_or_create_by!(nome: nome, departamento: departamento, usuario: usuario, formacao: formacao, ocupacao: ocupacao, email: email, turma: refer_turma)
          User.find_or_create_by!(nome: nome, matricula: email, perfil: "Docente", password: 123456, password_confirmation: 123456)
        end
      end
    end

    # aviso gerado
    flash[:success] = "JSON importado e processado com sucesso!"
    # redirect_to admin_gerenciamento_dashboard_path
  rescue => e
    flash[:error] = "Ocorreu um erro na importação: #{e.message}"
    # redirect_to admin_gerenciamento_dashboard_path
  end



  # tela de avaliações
  def admin_avaliacao
  end

  def discente
  end
end
