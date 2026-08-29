class CreateNutritionistServices < ActiveRecord::Migration[8.0]
  def change
    create_table :nutritionist_services, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      # The composite unique index below already covers lookups by nutritionist_id,
      # so the default single-column index would be redundant.
      t.references :nutritionist, null: false, foreign_key: true, index: false, type: :uuid
      t.references :service, null: false, foreign_key: true, type: :uuid

      t.string :street, null: false
      t.string :city, null: false
      t.integer :price_cents, null: false
      t.integer :duration_minutes, null: false

      t.timestamps
    end

    add_index :nutritionist_services, :city
    add_index :nutritionist_services,
              [ :nutritionist_id, :service_id, :city ],
              unique: true,
              name: "index_nutritionist_services_on_nutritionist_service_city"

    add_check_constraint :nutritionist_services, "price_cents > 0",
                         name: "check_nutritionist_services_price_positive"
    add_check_constraint :nutritionist_services, "duration_minutes > 0",
                         name: "check_nutritionist_services_duration_positive"
  end
end
