class AddLockedTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :locked_token, :string, limit: 256
    add_column :users, :locked_token_expired_at, :datetime
  end
end
