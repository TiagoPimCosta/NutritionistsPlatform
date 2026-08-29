class CreateAppointments < ActiveRecord::Migration[8.0]
  def change
    create_table :appointments, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      # Both foreign keys are covered by the composite indexes added below.
      t.references :guest, null: false, foreign_key: true, index: false, type: :uuid
      t.references :nutritionist_service, null: false, foreign_key: true, index: false, type: :uuid

      # Enum on the model: pending: 0, accepted: 1, rejected: 2, cancelled: 3.
      t.integer :status, null: false, default: 0

      # ends_at is derived from the service duration and stored, so overlap can be
      # answered by the database rather than by loading rows into Ruby.
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false

      t.timestamps
    end

    add_index :appointments, [ :nutritionist_service_id, :status ]
    add_index :appointments, [ :guest_id, :status ]
    add_index :appointments, [ :starts_at, :ends_at ]

    add_check_constraint :appointments, "ends_at > starts_at",
                         name: "check_appointments_ends_after_starts"
  end
end
