class DropWeathers < ActiveRecord::Migration[7.1]
  def change
    drop_table :weathers
    drop_table :weatherdatas
    drop_table :whethers
  end
end
