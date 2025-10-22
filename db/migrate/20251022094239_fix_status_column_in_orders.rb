class FixStatusColumnInOrders < ActiveRecord::Migration[7.1]
  def change
    # 1. Xóa cột string cũ
    remove_column :orders, :status, :string

    # 2. Tạo lại cột mới kiểu integer, mặc định = 0
    add_column :orders, :status, :integer, default: 0
  end
end
