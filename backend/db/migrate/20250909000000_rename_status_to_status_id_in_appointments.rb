class RenameStatusToStatusIdInAppointments < ActiveRecord::Migration[8.0]
  def up
    rename_column :appointments, :status, :status_id
    change_column :appointments, :status_id, :integer, using: "status_id::integer"
  end

  def down
    change_column :appointments, :status_id, :boolean, using: "status_id::boolean"
    rename_column :appointments, :status_id, :status
  end
end
