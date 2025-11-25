class ChangeStockAndPriceToSafeTypesInFoodDrinks < ActiveRecord::Migration[7.0]
  def change
    # stock: từ integer -> bigint (đủ lớn)
    change_column :food_drinks, :stock, :bigint

    # price: từ integer hoặc float -> decimal, precision/scale lớn
    # precision: tổng số chữ số, scale: số chữ số thập phân
    change_column :food_drinks, :price, :decimal, precision: 20, scale: 2
  end
end
