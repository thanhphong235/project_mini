class ChangeStatusToIntegerInOrders < ActiveRecord::Migration[7.1]
  def up
    # Chuyển giá trị string -> integer theo enum
    mapping = {
      "pending" => 0,
      "confirmed" => 1,
      "delivering" => 2,
      "completed" => 3,
      "cancelled" => 4
    }

    # Thêm cột tạm để lưu dạng số
    add_column :orders, :status_tmp, :integer, default: 0

    # Cập nhật dữ liệu cũ
    Order.reset_column_information
    Order.find_each do |order|
      order.update_column(:status_tmp, mapping[order.status] || 0)
    end

    # Xóa cột cũ và đổi tên cột mới
    remove_column :orders, :status
    rename_column :orders, :status_tmp, :status
  end

  def down
    change_column :orders, :status, :string
  end
end
