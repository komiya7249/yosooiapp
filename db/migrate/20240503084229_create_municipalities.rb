class CreateMunicipalities < ActiveRecord::Migration[7.1]
  def change
    create_table :municipalities do |t|
      t.string :name
      t.integer :latitude
      t.integer :longitude

      t.timestamps
    end
  end
end
