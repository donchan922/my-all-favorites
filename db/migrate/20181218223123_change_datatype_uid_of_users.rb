class ChangeDatatypeUidOfUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :uid, :integer
  end
end
