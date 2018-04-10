class AddStyleDataToImages < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :style_data, :string
  end
end
