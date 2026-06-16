class Question < ApplicationRecord
  belongs_to :form_template

  has_many :choices, dependent: :destroy

  enum :question_type,
       {
         essay: 0,
         multiple_choice: 1
       }
end