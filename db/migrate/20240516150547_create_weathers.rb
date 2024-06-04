class CreateWeathers < ActiveRecord::Migration[7.1]
  def change
    create_table :weathers do |t|
      t.integer :municipalities_id
      t.float :temperature_max
      t.float :temperature_min
      t.float :precipitation_probability
      t.string :weather_code
      t.string :wear_symbol
      t.float :apparent_temperature_max
      t.float :apparent_temperture_min
      t.date :time
      t.string :municipalities_name

      t.timestamps
    end
  end
end
