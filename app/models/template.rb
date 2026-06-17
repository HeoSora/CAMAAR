class Template < ApplicationRecord
  belongs_to :user

  validates :nome, presence: true
  validates :semestre, presence: true
end
