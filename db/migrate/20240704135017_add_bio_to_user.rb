class AddBioToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :bio, :text, default: "No bio yet"
  end
end
