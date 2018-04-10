class AddModerateToImages < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :moderate, :boolean, default: false
  end
end
