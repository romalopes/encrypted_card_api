class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :login
      t.string :hashed_password

      t.timestamps
    end
    add_index :users, [:login], unique: true
  end
end
