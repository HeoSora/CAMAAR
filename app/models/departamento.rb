# app/models/departamento.rb
class Departamento < ApplicationRecord
  has_many :docentes, dependent: :restrict_with_error

  validates :nome, presence: true, uniqueness: true
end
