class AddOmniauthToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    # add_column :users, :name, :string

    # Thêm index kết hợp để đảm bảo uniqueness
    add_index :users, [:provider, :uid], unique: true
  end
end
