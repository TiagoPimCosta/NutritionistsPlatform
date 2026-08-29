class CreateGuests < ActiveRecord::Migration[8.0]
  def change
    create_table :guests, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.string :name, null: false
      t.string :email, null: false

      t.timestamps
    end

    # Guest.find_by(email:) assumes uniqueness; enforce it in the database,
    # case-insensitively, since email is how a returning guest is recognised.
    add_index :guests, "lower(email)", unique: true, name: "index_guests_on_lower_email"
  end
end
