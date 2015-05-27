class AddGuidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :guid, :string

    User.all.each do |user|
       user.guid = SecureRandom.hex(4)
       user.save!
    end
  end
end
