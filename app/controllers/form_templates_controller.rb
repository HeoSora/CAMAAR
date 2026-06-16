class FormTemplatesController < ApplicationController
  before_action :require_login
  before_action :require_admin

  def index
    @form_templates = current_user.form_templates
  end
  
  def new
    @form_template = FormTemplate.new
  end

  def create
    @form_template = current_user.form_templates.build(form_template_params)

    if @form_template.save
      redirect_to @form_template, notice: "Template criado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @form_template = current_user.form_templates.find(params[:id])
  end

  def destroy
    @form_template = current_user.form_templates.find(params[:id])

    @form_template.destroy

    redirect_to form_templates_path,
                notice: "Template excluído com sucesso!"
  end

  private

  def form_template_params
    params.require(:form_template).permit(:title, :description)
  end

  def require_admin
    redirect_to root_path unless admin?
  end
end