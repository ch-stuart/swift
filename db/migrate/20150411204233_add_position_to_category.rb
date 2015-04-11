class AddPositionToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :position, :integer

    Category.all.each_with_index do |category, index|
      category.position = index + 1
      category.save!
    end
  end
end
