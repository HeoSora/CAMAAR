require "json"

class DashboardsController < ApplicationController
  before_action :require_login

  layout "admin_layout", only: [ :admin, :admin_gerenciamento, :admin_avaliacao ]

  def admin
  end

  def admin_gerenciamento
    @turmas = Turma.all
    @discentes = Discente.all
    @docentes = Docente.all
  end

  def importar_json
    return redirecionar_json_vazio if json_vazio?

    registrar_arquivo_recebido

    if importar_dados_json
      flash[:success] = "JSON importado com sucesso!"
    else
      flash[:alert] = "Ocorreu um problema ao importar o JSON."
    end

    redirect_to admin_gerenciamento_dashboard_path
  rescue StandardError => e
    tratar_erro_importacao(e)
  end

  def admin_avaliacao
  end

  def discente
  end

  private

  def json_vazio?
    params[:json].blank?
  end

  def redirecionar_json_vazio
    puts "ERRO: O parâmetro 'json' veio vazio!"
    flash[:error] = "Por favor, selecione um arquivo JSON."
    redirect_to admin_gerenciamento_dashboard_path
  end

  def registrar_arquivo_recebido
    puts "Arquivo recebido com sucesso: #{params[:json].original_filename}"
  end

  def importar_dados_json
    resultado = Importer::AcademicDataImporter.import!(params[:json])

    if resultado
      puts "SUCESSO: O Service Object terminou sem erros."
      true
    else
      puts "AVISO: O Service retornou falso."
      false
    end
  end

  def tratar_erro_importacao(erro)
    puts "EXCEÇÃO CAPTURADA NO CONTROLLER: #{erro.message}"
    puts erro.backtrace.first(2)

    flash[:error] = "Ocorreu um erro na importação: #{erro.message}"
    redirect_to admin_gerenciamento_dashboard_path
  end
end
