class CreateQuizes < ActiveRecord::Migration[8.1]
  def change
    create_table :quizes do |t|
      t.string :title, null: false
      t.text :description
      t.boolean :published, default: false
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
