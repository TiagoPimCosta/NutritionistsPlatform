class MoveFieldsFromNutritionistsToNutritionistsServices < ActiveRecord::Migration[8.0]
  def up
    add_column :nutritionists_services, :street, :string
    add_column :nutritionists_services, :city, :string
    add_column :nutritionists_services, :price, :integer

    execute <<~SQL
      UPDATE nutritionists_services AS ns
      SET street = n.street,
          city = n.city,
          price = n.price
      FROM nutritionists AS n
      WHERE ns.nutritionist_id = n.id
    SQL

    remove_column :nutritionists, :street, :string
    remove_column :nutritionists, :city, :string
    remove_column :nutritionists, :price, :integer
  end

  def down
    add_column :nutritionists, :street, :string
    add_column :nutritionists, :city, :string
    add_column :nutritionists, :price, :integer

    execute <<~SQL
      UPDATE nutritionists AS n
      SET street = ns.street,
          city = ns.city,
          price = ns.price
      FROM (
        SELECT DISTINCT ON (nutritionist_id) nutritionist_id, street, city, price
        FROM nutritionists_services
        ORDER BY nutritionist_id, id
      ) AS ns
      WHERE n.id = ns.nutritionist_id
    SQL

    remove_column :nutritionists_services, :street, :string
    remove_column :nutritionists_services, :city, :string
    remove_column :nutritionists_services, :price, :integer
  end
end


