class CreateNutritionists < ActiveRecord::Migration[8.0]
  def change
    create_table :nutritionists, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.string :name, null: false
      t.string :license_number, null: false
      t.string :title, null: false

      t.timestamps
    end

    add_index :nutritionists, :name
    add_index :nutritionists, :license_number, unique: true
  end
end
