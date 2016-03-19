class CreateCreditCards < ActiveRecord::Migration[5.0]
  def change
    create_table :credit_cards do |t|
      t.integer :user_id
      t.string :key
      t.string :credit_card_number

      t.timestamps
    end
    add_index :credit_cards, [:user_id, :key], unique: true
  end
end
