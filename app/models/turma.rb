# app/models/turma.rb
class Turma < ApplicationRecord
  belongs_to :disciplina
  belongs_to :docente

  has_many :matriculas,   dependent: :destroy
  has_many :discentes,    through: :matriculas
  has_many :formularios,  dependent: :restrict_with_error

  validates :codigo,   presence: true
  validates :semestre, presence: true

  def nome_completo
    "#{disciplina.nome} - #{codigo} (#{semestre})"
  end
end

# app/models/matricula.rb
class Matricula < ApplicationRecord
  belongs_to :discente
  belongs_to :turma

  validates :discente_id, uniqueness: { scope: :turma_id,
    message: "já está matriculado nesta turma" }
end

# app/models/template.rb
class Template < ApplicationRecord
  belongs_to :docente

  has_many :questao_templates, dependent: :destroy
  has_many :formularios,       dependent: :restrict_with_error

  validates :titulo, presence: true
  validate  :deve_ter_ao_menos_uma_questao, on: :update

  private

  def deve_ter_ao_menos_uma_questao
    if questao_templates.empty?
      errors.add(:base, "Template deve ter ao menos uma questão")
    end
  end
end

# app/models/questao_template.rb
class QuestaoTemplate < ApplicationRecord
  belongs_to :template

  has_many :opcao_questoes, dependent: :destroy
  has_many :questoes,       dependent: :restrict_with_error

  enum :tipo, { aberta: 0, multipla: 1 }

  validates :enunciado, presence: true
  validates :tipo,      presence: true
end

# app/models/opcao_questao.rb
class OpcaoQuestao < ApplicationRecord
  belongs_to :questao_template

  validates :texto, presence: true
end

# app/models/formulario.rb
class Formulario < ApplicationRecord
  belongs_to :turma
  belongs_to :template

  has_many :questoes,          dependent: :destroy
  has_many :envio_formularios, dependent: :destroy

  validates :titulo, presence: true

  scope :abertos,   -> { where("prazo IS NULL OR prazo > ?", Time.current) }
  scope :fechados,  -> { where("prazo IS NOT NULL AND prazo <= ?", Time.current) }

  def aberto?
    prazo.nil? || prazo > Time.current
  end

  def fechado?
    !aberto?
  end

  def status
    aberto? ? :aberto : :fechado
  end

  def status_label
    aberto? ? "Aberto" : "Fechado"
  end

  def respondido_por?(discente)
    envio_formularios.exists?(discente: discente)
  end

  def total_discentes
    turma.discentes.count
  end

  def total_respostas
    envio_formularios.count
  end
end

# app/models/questao.rb
class Questao < ApplicationRecord
  belongs_to :formulario
  belongs_to :questao_template

  has_many :respostas, dependent: :destroy

  enum :tipo, { aberta: 0, multipla: 1 }

  validates :enunciado, presence: true

  delegate :opcao_questoes, to: :questao_template
end

# app/models/envio_formulario.rb
class EnvioFormulario < ApplicationRecord
  belongs_to :formulario
  belongs_to :discente

  has_many :respostas, dependent: :destroy

  validates :formulario_id, uniqueness: {
    scope: :discente_id,
    message: "Você já respondeu este formulário"
  }

  validate :formulario_deve_estar_aberto, on: :create

  before_create :registrar_envio

  private

  def registrar_envio
    self.enviado_em = Time.current
  end

  def formulario_deve_estar_aberto
    if formulario&.fechado?
      errors.add(:base, "O prazo para responder este formulário já encerrou")
    end
  end
end

# app/models/resposta.rb
class Resposta < ApplicationRecord
  belongs_to :envio_formulario
  belongs_to :questao

  validates :conteudo, presence: true
end
