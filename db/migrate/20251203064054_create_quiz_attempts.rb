class CreateQuizAttempts < ActiveRecord::Migration[8.1]
  def change
    create_table :quiz_attempts do |t|
      t.string :participant_name, null: false
      t.string :participant_email, null: false
      t.integer :score, default: 0
      t.integer :total_questions, default: 0
      t.references :quizes, null: false, foreign_key: true
      t.datetime :completed_at
      t.timestamps
    end

    add_index :quiz_attempts, :participant_email
  end
end
