# app/models/discente.rb
class Discente < ApplicationRecord
  belongs_to :usuario

  has_many :matriculas,         dependent: :destroy
  has_many :turmas,             through: :matriculas
  has_many :envio_formularios,  dependent: :destroy
  has_many :formularios,        through: :envio_formularios

  validates :curso,      presence: true
  validates :matricula,  presence: true, uniqueness: true

  delegate :nome, :email, to: :usuario

  def formularios_disponiveis
    turmas_ids = turmas.pluck(:id)
    formularios_respondidos_ids = envio_formularios.pluck(:formulario_id)

    Formulario
      .where(turma_id: turmas_ids)
      .where.not(id: formularios_respondidos_ids)
  end

  def ja_respondeu?(formulario)
    envio_formularios.exists?(formulario: formulario)
  end
end

# app/models/docente.rb
class Docente < ApplicationRecord
  belongs_to :usuario
  belongs_to :departamento

  has_many :turmas,     dependent: :restrict_with_error
  has_many :templates,  dependent: :restrict_with_error

  delegate :nome, :email, to: :usuario
end

# app/models/departamento.rb
class Departamento < ApplicationRecord
  has_many :docentes, dependent: :restrict_with_error

  validates :nome, presence: true, uniqueness: true
end

# app/models/disciplina.rb
class Disciplina < ApplicationRecord
  has_many :turmas, dependent: :restrict_with_error

  validates :codigo, presence: true, uniqueness: true
  validates :nome,   presence: true
end
