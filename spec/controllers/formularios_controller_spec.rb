# spec/controllers/formularios_controller_spec.rb
require 'rails_helper'

RSpec.describe FormulariosController, type: :controller do
  let(:departamento) { create(:departamento) }
  let(:usuario_doc)  { create(:usuario, perfil: :docente) }
  let(:docente)      { create(:docente, usuario: usuario_doc, departamento: departamento) }
  let(:disciplina)   { create(:disciplina) }
  let(:turma)        { create(:turma, disciplina: disciplina, docente: docente) }
  let(:template)     { create(:template, docente: docente) }

  let(:usuario_disc) { create(:usuario, perfil: :discente, primeiro_acesso: false) }
  let(:discente)     { create(:discente, usuario: usuario_disc) }

  before do
    session[:usuario_id] = usuario_disc.id
    create(:matricula, discente: discente, turma: turma)
  end

  describe "GET #index" do
    let!(:formulario_pendente)  { create(:formulario, turma: turma, template: template, prazo: 7.days.from_now) }
    let!(:formulario_respondido) do
      f = create(:formulario, turma: turma, template: template, prazo: 7.days.from_now)
      create(:envio_formulario, formulario: f, discente: discente)
      f
    end
    let!(:formulario_fechado) { create(:formulario, turma: turma, template: template, prazo: 1.day.ago) }

    it "retorna status 200" do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it "separa formulários em pendentes, respondidos e fechados" do
      get :index
      expect(assigns(:formularios_pendentes)).to include(formulario_pendente)
      expect(assigns(:formularios_respondidos)).to include(formulario_respondido)
      expect(assigns(:formularios_fechados)).to include(formulario_fechado)
    end

    it "não inclui formulário respondido nos pendentes" do
      get :index
      expect(assigns(:formularios_pendentes)).not_to include(formulario_respondido)
    end

    it "não mostra formulários de turmas que o discente não está matriculado" do
      outra_turma = create(:turma, disciplina: disciplina, docente: docente)
      formulario_outro = create(:formulario, turma: outra_turma, template: template)
      get :index
      todos = assigns(:formularios_pendentes) +
              assigns(:formularios_respondidos) +
              assigns(:formularios_fechados)
      expect(todos).not_to include(formulario_outro)
    end

    context "sem autenticação" do
      before { session[:usuario_id] = nil }

      it "redireciona para login" do
        get :index
        expect(response).to redirect_to(login_path)
      end
    end

    context "quando logado como docente" do
      before { session[:usuario_id] = usuario_doc.id }

      it "redireciona para root com alerta" do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET #show" do
    let!(:formulario) { create(:formulario, turma: turma, template: template, prazo: 7.days.from_now) }

    it "retorna status 200 para discente matriculado" do
      get :show, params: { id: formulario.id }
      expect(response).to have_http_status(:ok)
    end

    context "quando o formulário está fechado" do
      let!(:formulario_fechado) { create(:formulario, turma: turma, template: template, prazo: 1.day.ago) }

      it "redireciona para index com alerta de prazo" do
        get :show, params: { id: formulario_fechado.id }
        expect(response).to redirect_to(formularios_path)
        expect(flash[:alert]).to match(/prazo/i)
      end
    end

    context "quando discente já respondeu" do
      before { create(:envio_formulario, formulario: formulario, discente: discente) }

      it "redireciona para minha_resposta" do
        get :show, params: { id: formulario.id }
        expect(response).to redirect_to(minha_resposta_formulario_path(formulario))
      end
    end

    context "quando discente não está matriculado na turma" do
      let(:outra_turma)    { create(:turma, disciplina: disciplina, docente: docente) }
      let!(:outro_form)    { create(:formulario, turma: outra_turma, template: template) }

      it "redireciona com alerta de acesso negado" do
        get :show, params: { id: outro_form.id }
        expect(response).to redirect_to(formularios_path)
        expect(flash[:alert]).to be_present
      end
    end

    context "quando formulário não existe" do
      it "redireciona com alerta" do
        get :show, params: { id: 9999999 }
        expect(response).to redirect_to(formularios_path)
      end
    end
  end

  describe "GET #minha_resposta" do
    let!(:formulario) { create(:formulario, turma: turma, template: template) }

    context "quando discente respondeu" do
      let!(:envio) { create(:envio_formulario, formulario: formulario, discente: discente) }

      it "retorna status 200" do
        get :minha_resposta, params: { id: formulario.id }
        expect(response).to have_http_status(:ok)
      end

      it "atribui o envio correto" do
        get :minha_resposta, params: { id: formulario.id }
        expect(assigns(:envio)).to eq(envio)
      end
    end

    context "quando discente não respondeu" do
      it "redireciona com alerta" do
        get :minha_resposta, params: { id: formulario.id }
        expect(response).to redirect_to(formularios_path)
        expect(flash[:alert]).to be_present
      end
    end
  end
end
