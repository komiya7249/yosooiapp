class CreateWeathers < ActiveRecord::Migration[7.1]
  def change
    create_table :weathers do |t|
      t.integer :HighestTemperature

      t.timestamps
    end
  end
end
