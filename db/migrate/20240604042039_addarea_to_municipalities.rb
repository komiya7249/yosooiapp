class AddareaToMunicipalities < ActiveRecord::Migration[7.1]
  def change
    add_column :municipalities, :area, :string
  end
end
