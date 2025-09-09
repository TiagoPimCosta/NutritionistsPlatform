class AddForeignKeyToAppointmentsStatusId < ActiveRecord::Migration[8.0]
  def change
    # Add foreign key constraint for status_id
    add_foreign_key :appointments, :appointment_statuses, column: :status_id, primary_key: :id
  end
end
