class RenameAddressToStreetInNutritionists < ActiveRecord::Migration[8.0]
  def change
    rename_column :nutritionists, :address, :street
  end
end
