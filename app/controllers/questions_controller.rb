class QuestionsController < ApplicationController
  before_action :require_login
  before_action :require_admin

  def new
    @form_template = FormTemplate.find(params[:form_template_id])
    @question = @form_template.questions.build
  end

  def create
    @form_template = FormTemplate.find(params[:form_template_id])
    @question = @form_template.questions.build(question_params)

    if @question.save
      redirect_to @form_template, notice: "Pergunta criada com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def question_params
    params.require(:question)
          .permit(:statement, :question_type)
  end

  def require_admin
    redirect_to root_path unless admin?
  end
end