class CreateAnswers < ActiveRecord::Migration[8.1]
  def change
    create_table :answers do |t|
      t.references :question, null: false, foreign_key: true
      t.references :quiz_attempt, null: false, foreign_key: true
      t.references :selected_option, null: false, foreign_key: { to_table: :options }
      t.boolean :is_correct, null: false, default: false

      t.timestamps
    end

    add_index :answers, [:question_id, :quiz_attempt_id], unique: true, name: 'unique_question_quiz_attempt'
  end
end