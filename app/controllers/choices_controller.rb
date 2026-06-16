class ChoicesController < ApplicationController
  before_action :require_login
  before_action :require_admin
  before_action :set_question
  before_action :ensure_multiple_choice

  def index
    @choices = @question.choices
  end

  def new
    @choice = @question.choices.build
  end

  def create
    @choice = @question.choices.build(choice_params)

    if @choice.save
      redirect_to form_template_question_choices_path(
        @question.form_template,
        @question
      ), notice: "Alternativa criada com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def ensure_multiple_choice
    redirect_to @question.form_template unless @question.multiple_choice?
  end

  def choice_params
    params.require(:choice).permit(:text)
  end

  def require_admin
    redirect_to root_path unless admin?
  end
end