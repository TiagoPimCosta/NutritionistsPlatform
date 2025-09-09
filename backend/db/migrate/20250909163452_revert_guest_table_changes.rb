class RevertGuestTableChanges < ActiveRecord::Migration[8.0]
  def up
    # Recreate guests table
    create_table :guests do |t|
      t.string :name
      t.string :email
      t.timestamps
    end

    # Add guest_id back to appointments
    add_reference :appointments, :guest, null: false, foreign_key: true

    # Remove guest_name and guest_email columns
    remove_column :appointments, :guest_name, :string
    remove_column :appointments, :guest_email, :string
  end

  def down
    # This would reapply the original migration
    add_column :appointments, :guest_name, :string, null: false
    add_column :appointments, :guest_email, :string, null: false

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
end
