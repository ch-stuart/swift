class CreateContactsTable < ActiveRecord::Migration

    def change
        create_table :contacts do |t|
            t.text :email
            t.boolean :archived, :null => false, :default => false

            t.timestamps
        end
    end

end
