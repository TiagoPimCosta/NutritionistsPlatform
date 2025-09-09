class AddCityToNutritionists < ActiveRecord::Migration[8.0]
  def change
    add_column :nutritionists, :city, :string
  end
end
