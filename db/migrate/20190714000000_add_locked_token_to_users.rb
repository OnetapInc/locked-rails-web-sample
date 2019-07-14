class AddLockedTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :locked_token, :string
  end
end
