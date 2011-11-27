class AddSignOnTheFrontDoorToCompanies < ActiveRecord::Migration
  def self.up
      add_column :companies, :front_door_sign, :text
  end

  def self.down
      remove_column :companies, :front_door_sign
  end
end
