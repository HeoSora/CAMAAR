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
    "#{disciplina.nome} – #{codigo} (#{semestre})"
  end
class Turma < ApplicationRecord
  belongs_to :departamento

  validates :codigo, presence: true
  validates :nome, presence: true
end
