class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.text :relationship_status
      t.text :hometown
      t.text :current_city
      t.text :favorite_quote
      t.text :about_you
      t.text :birthdate 

      t.timestamps
    end
  end
end
