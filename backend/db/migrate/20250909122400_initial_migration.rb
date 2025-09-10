class InitialMigration < ActiveRecord::Migration[8.0]
  def change
    create_table :guests do |t|
      t.string :name
      t.string :email

      t.timestamps
    end

    create_table :services do |t|
      t.string :name

      t.timestamps
    end

    create_table :nutritionists do |t|
      t.string :name
      t.string :street
      t.string :city
      t.integer :price

      t.timestamps
    end

    create_table :nutritionists_services do |t|
      t.references :nutritionist, null: false, foreign_key: true
      t.references :service, null: false, foreign_key: true

      t.timestamps
    end

    create_table :appointments do |t|
      t.datetime :date
      t.references :status, null: false, foreign_key: true
      t.references :nutritionist, null: false, foreign_key: true
      t.references :guest, null: false, foreign_key: true

      t.timestamps
    end
  end
end
