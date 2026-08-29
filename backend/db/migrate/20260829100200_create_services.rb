class CreateServices < ActiveRecord::Migration[8.0]
  def change
    create_table :services, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :services, :name, unique: true
  end
end
