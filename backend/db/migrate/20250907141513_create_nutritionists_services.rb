class CreateNutritionistsServices < ActiveRecord::Migration[8.0]
  def change
    create_table :nutritionists_services do |t|
      t.references :nutritionist, null: false, foreign_key: true
      t.references :service, null: false, foreign_key: true

      t.timestamps
    end
  end
end
