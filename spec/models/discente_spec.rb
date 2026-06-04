# spec/models/discente_spec.rb
require 'rails_helper'

RSpec.describe Discente, type: :model do
  let(:departamento) { create(:departamento) }
  let(:usuario_doc)  { create(:usuario, perfil: :docente) }
  let(:docente)      { create(:docente, usuario: usuario_doc, departamento: departamento) }
  let(:disciplina)   { create(:disciplina) }
  let(:turma_a)      { create(:turma, disciplina: disciplina, docente: docente) }
  let(:turma_b)      { create(:turma, disciplina: disciplina, docente: docente) }

  let(:usuario_disc) { create(:usuario, perfil: :discente) }
  let(:discente)     { create(:discente, usuario: usuario_disc) }

  before do
    create(:matricula, discente: discente, turma: turma_a)
  end

  describe "#formularios_disponiveis" do
    context "quando existe formulário na turma do discente" do
      let!(:template)   { create(:template, docente: docente) }
      let!(:formulario) { create(:formulario, turma: turma_a, template: template) }

      it "retorna o formulário" do
        expect(discente.formularios_disponiveis).to include(formulario)
      end

      context "quando o discente já respondeu" do
        before { create(:envio_formulario, discente: discente, formulario: formulario) }

        it "não retorna o formulário já respondido" do
          expect(discente.formularios_disponiveis).not_to include(formulario)
        end
      end
    end

    context "quando o formulário é de outra turma (não matriculado)" do
      let!(:template)   { create(:template, docente: docente) }
      let!(:formulario) { create(:formulario, turma: turma_b, template: template) }

      it "não retorna o formulário" do
        expect(discente.formularios_disponiveis).not_to include(formulario)
      end
    end
  end

  describe "#ja_respondeu?" do
    let!(:template)   { create(:template, docente: docente) }
    let!(:formulario) { create(:formulario, turma: turma_a, template: template) }

    it "retorna false quando não respondeu" do
      expect(discente.ja_respondeu?(formulario)).to be false
    end

    it "retorna true quando já respondeu" do
      create(:envio_formulario, discente: discente, formulario: formulario)
      expect(discente.ja_respondeu?(formulario)).to be true
    end
  end
end

# spec/models/formulario_spec.rb
RSpec.describe Formulario, type: :model do
  let(:departamento) { create(:departamento) }
  let(:usuario_doc)  { create(:usuario, perfil: :docente) }
  let(:docente)      { create(:docente, usuario: usuario_doc, departamento: departamento) }
  let(:disciplina)   { create(:disciplina) }
  let(:turma)        { create(:turma, disciplina: disciplina, docente: docente) }
  let(:template)     { create(:template, docente: docente) }

  describe "scopes" do
    let!(:formulario_aberto)  { create(:formulario, turma: turma, template: template, prazo: 7.days.from_now) }
    let!(:formulario_fechado) { create(:formulario, turma: turma, template: template, prazo: 1.day.ago) }
    let!(:formulario_sem_prazo) { create(:formulario, turma: turma, template: template, prazo: nil) }

    it "scope abertos retorna apenas formulários com prazo futuro ou sem prazo" do
      expect(Formulario.abertos).to include(formulario_aberto, formulario_sem_prazo)
      expect(Formulario.abertos).not_to include(formulario_fechado)
    end

    it "scope fechados retorna apenas formulários com prazo passado" do
      expect(Formulario.fechados).to include(formulario_fechado)
      expect(Formulario.fechados).not_to include(formulario_aberto, formulario_sem_prazo)
    end
  end

  describe "#aberto?" do
    it "retorna true quando prazo é futuro" do
      f = build(:formulario, turma: turma, template: template, prazo: 1.day.from_now)
      expect(f.aberto?).to be true
    end

    it "retorna true quando não tem prazo" do
      f = build(:formulario, turma: turma, template: template, prazo: nil)
      expect(f.aberto?).to be true
    end

    it "retorna false quando prazo passou" do
      f = build(:formulario, turma: turma, template: template, prazo: 1.day.ago)
      expect(f.aberto?).to be false
    end
  end

  describe "#respondido_por?" do
    let(:usuario_disc) { create(:usuario, perfil: :discente) }
    let(:discente)     { create(:discente, usuario: usuario_disc) }
    let(:formulario)   { create(:formulario, turma: turma, template: template) }

    it "retorna false quando discente não respondeu" do
      expect(formulario.respondido_por?(discente)).to be false
    end

    it "retorna true quando discente respondeu" do
      create(:envio_formulario, formulario: formulario, discente: discente)
      expect(formulario.respondido_por?(discente)).to be true
    end
  end

  describe "validações" do
    it "é inválido sem título" do
      f = build(:formulario, titulo: nil, turma: turma, template: template)
      expect(f).not_to be_valid
    end
  end
end
