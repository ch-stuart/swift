class ChangeDescriptionColumnTypeFromStringToText < ActiveRecord::Migration
  def self.up
    remove_column :companies, :description
    add_column :companies, :description, :text
  end

  def self.down
    remove_column :companies, :description
    add_column :companies, :description, :string
  end
end
