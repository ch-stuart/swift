class AddIsAttendingCampoutIn2015ToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_attending_campout_in_2015, :boolean, null: false, default: false
  end
end
