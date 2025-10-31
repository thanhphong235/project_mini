class AddStatusTmpToOrders < ActiveRecord::Migration[7.1]
  def change
    # Thêm cột tạm để lưu dạng integer
    add_column :orders, :status_tmp, :integer, default: 0
  end
end
