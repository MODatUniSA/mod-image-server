class AddRudeAndFunnyToImages < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :rude, :boolean
    add_column :images, :funny, :boolean
  end
end
