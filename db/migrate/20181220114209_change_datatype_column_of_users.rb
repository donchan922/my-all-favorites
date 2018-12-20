class ChangeDatatypeColumnOfUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :uid, :string
  end
end
