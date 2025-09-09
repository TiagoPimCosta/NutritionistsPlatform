class MigrateAppointmentsGuestToNameAndEmail < ActiveRecord::Migration[8.0]
  def up
    add_column :appointments, :guest_name, :string
    add_column :appointments, :guest_email, :string

    execute <<~SQL
      UPDATE appointments
      SET guest_name = g.name,
          guest_email = g.email
      FROM guests g
      WHERE appointments.guest_id = g.id;
    SQL

    change_column_null :appointments, :guest_name, false
    change_column_null :appointments, :guest_email, false

    if foreign_key_exists?(:appointments, :guests)
      remove_foreign_key :appointments, :guests
    end
    if index_exists?(:appointments, :guest_id)
      remove_index :appointments, :guest_id
    end
    if column_exists?(:appointments, :guest_id)
      remove_column :appointments, :guest_id
    end

    drop_table :guests, if_exists: true
  end

  def down
    create_table :guests do |t|
      t.string :name
      t.string :email
      t.timestamps
    end

    add_reference :appointments, :guest, null: false, foreign_key: true

    execute <<~SQL
      INSERT INTO guests (name, email, created_at, updated_at)
      SELECT DISTINCT guest_name, guest_email, NOW(), NOW()
      FROM appointments;
    SQL

    execute <<~SQL
      UPDATE appointments
      SET guest_id = g.id
      FROM guests g
      WHERE appointments.guest_name = g.name
        AND appointments.guest_email = g.email;
    SQL

    remove_column :appointments, :guest_name if column_exists?(:appointments, :guest_name)
    remove_column :appointments, :guest_email if column_exists?(:appointments, :guest_email)
  end
end
