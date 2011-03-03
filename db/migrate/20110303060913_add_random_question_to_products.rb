class AddRandomQuestionToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :question, :string
    add_column :products, :answer, :string
  end

  def self.down
    remove_column :products, :answer
    remove_column :products, :question
  end
end
