class CreateTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :tokens do |t|
      t.integer :user_id
      t.string :token

      t.timestamps
    end
    add_index :tokens, [:user_id, :token], unique: true
  end
end
