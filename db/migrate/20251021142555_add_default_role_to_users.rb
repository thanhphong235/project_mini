class AddDefaultRoleToUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :role, from: nil, to: "user"
  end
end
