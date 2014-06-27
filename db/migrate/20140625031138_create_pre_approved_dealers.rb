class CreatePreApprovedDealers < ActiveRecord::Migration
  def change
    create_table :pre_approved_dealers do |t|
      t.string :email

      t.timestamps
    end
  end
end
