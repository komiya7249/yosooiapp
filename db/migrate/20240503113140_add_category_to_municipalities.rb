class AddCategoryToMunicipalities < ActiveRecord::Migration[7.1]
  def change
    add_column :municipalities, :category, :string
  end
end
