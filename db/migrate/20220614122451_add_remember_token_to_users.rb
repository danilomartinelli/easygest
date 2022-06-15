class AddRememberTokenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :remember_token, :string, null: false, default: ""
    add_index :users, :remember_token, unique: true
  end
end
