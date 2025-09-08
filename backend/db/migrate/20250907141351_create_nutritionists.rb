class CreateNutritionists < ActiveRecord::Migration[8.0]
  def change
    create_table :nutritionists do |t|
      t.string :name
      t.string :address
      t.integer :price

      t.timestamps
    end
  end
end
