# app/controllers/formularios_controller.rb
class FormulariosController < ApplicationController
  before_action :exigir_discente!
  before_action :set_formulario, only: [:show]

  # GET /formularios
  # Issue #8: Lista formulários disponíveis para o discente responder
  def index
    @turmas = discente_atual.turmas.includes(:disciplina, :docente)

    @formularios_pendentes = formularios_do_discente
      .abertos
      .where.not(id: formularios_ja_respondidos)
      .includes(:turma, :template)
      .order(prazo: :asc)

    @formularios_respondidos = formularios_do_discente
      .joins(:envio_formularios)
      .where(envio_formularios: { discente_id: discente_atual.id })
      .includes(:turma, :template)
      .order("envio_formularios.enviado_em desc")

    @formularios_fechados = formularios_do_discente
      .fechados
      .where.not(id: formularios_ja_respondidos)
      .includes(:turma, :template)
      .order(prazo: :desc)
  end

  # GET /formularios/:id
  # Mostra detalhes do formulário (preview antes de responder)
  def show
    @ja_respondeu = discente_atual.ja_respondeu?(@formulario)
    @envio = discente_atual.envio_formularios.find_by(formulario: @formulario)

    if @ja_respondeu
      redirect_to minha_resposta_formulario_path(@formulario),
        notice: "Você já respondeu este formulário."
      return
    end

    unless @formulario.aberto?
      redirect_to formularios_path,
        alert: "O prazo para responder este formulário já encerrou."
      return
    end

    unless discente_pertence_a_turma?(@formulario.turma)
      redirect_to formularios_path,
        alert: "Você não tem acesso a este formulário."
      return
    end

    @questoes = @formulario.questoes.includes(questao_template: :opcao_questoes)
  end

  # GET /formularios/:id/minha_resposta
  # Visualiza resposta já enviada (read-only)
  def minha_resposta
    @formulario = Formulario.find(params[:id])
    @envio = discente_atual.envio_formularios.find_by(formulario: @formulario)

    unless @envio
      redirect_to formularios_path,
        alert: "Você ainda não respondeu este formulário."
      return
    end

    unless discente_pertence_a_turma?(@formulario.turma)
      redirect_to formularios_path, alert: "Você não tem acesso a este formulário."
      return
    end

    @respostas = @envio.respostas.includes(questao: { questao_template: :opcao_questoes })
  end

  private

  def set_formulario
    @formulario = Formulario.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to formularios_path, alert: "Formulário não encontrado."
  end

  def formularios_do_discente
    turmas_ids = discente_atual.turmas.pluck(:id)
    Formulario.where(turma_id: turmas_ids)
  end

  def formularios_ja_respondidos
    discente_atual.envio_formularios.pluck(:formulario_id)
  end

  def discente_pertence_a_turma?(turma)
    discente_atual.turmas.include?(turma)
  end
end
