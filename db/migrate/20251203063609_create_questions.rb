class CreateQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :questions do |t|
      t.text :question_text, null: false
      t.string :question_type, null: false
      t.references :quizes, null: false, foreign_key: true

      t.timestamps
    end
  end
end
