class CreateResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :responses do |t|
      t.integer :user_id, null: false
      t.integer :question_id, null: false
      t.integer :answer_id, null: false
    end

    add_index :responses, [:user_id, :question_id], unique: true
  end
end
