class ConvertStatusToInteger < ActiveRecord::Migration[7.1]
  def up
    # Đảm bảo cột status đã là integer, tránh lỗi rename
    unless column_exists?(:orders, :status, :integer)
      add_column :orders, :status, :integer, default: 0
    end
  end

  def down
    change_column :orders, :status, :string
  end
end
