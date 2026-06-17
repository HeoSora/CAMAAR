class CreateQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :questions do |t|
      t.text :statement
      t.integer :question_type
      t.references :form_template, null: false, foreign_key: true

      t.timestamps
    end
  end
end
