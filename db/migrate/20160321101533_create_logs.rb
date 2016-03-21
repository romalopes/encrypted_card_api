class CreateLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :logs do |t|
      t.integer :user_id
      t.string :message
      t.string :description

      t.timestamps
    end

    add_column :users, :authentication_tries, :integer, :default => 0
    add_index :logs, [:id, :user_id], unique: true
  end
end
