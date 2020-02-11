class AddPhoneNumberToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :phone_number, :string, limit: 256, null: true
  end
end
