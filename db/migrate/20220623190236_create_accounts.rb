class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.belongs_to :workspace
      t.belongs_to :user

      t.timestamps
    end
  end
end
