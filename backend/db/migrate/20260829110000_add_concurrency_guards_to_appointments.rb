class AddConcurrencyGuardsToAppointments < ActiveRecord::Migration[8.0]
  def change
    enable_extension "btree_gist"

    add_column :appointments, :nutritionist_id, :uuid

    up_only do
      execute <<~SQL
        UPDATE appointments
        SET nutritionist_id = nutritionist_services.nutritionist_id
        FROM nutritionist_services
        WHERE nutritionist_services.id = appointments.nutritionist_service_id
      SQL
    end

    change_column_null :appointments, :nutritionist_id, false

    add_index :nutritionist_services, [ :id, :nutritionist_id ], unique: true,
              name: "index_nutritionist_services_on_id_and_nutritionist"

    remove_foreign_key :appointments, :nutritionist_services

    add_foreign_key :appointments, :nutritionist_services,
                    column: [ :nutritionist_service_id, :nutritionist_id ],
                    primary_key: [ :id, :nutritionist_id ]

    reversible do |direction|
      direction.up do
        execute <<~SQL
          ALTER TABLE appointments
          ADD CONSTRAINT no_overlapping_accepted_appointments
          EXCLUDE USING gist (
            nutritionist_id WITH =,
            tsrange(starts_at, ends_at) WITH &&
          ) WHERE (status = 1)
        SQL
      end

      direction.down do
        execute <<~SQL
          ALTER TABLE appointments
          DROP CONSTRAINT no_overlapping_accepted_appointments
        SQL
      end
    end
  end
end
