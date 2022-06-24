class CreateWorkspaces < ActiveRecord::Migration[7.0]
  def change
    create_table :workspaces do |t|
      t.string :name, null: false
      t.string :nickname, null: false, unique: true

      t.timestamps
    end
  end
end
