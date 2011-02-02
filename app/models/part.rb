class Part < ActiveRecord::Base

    belongs_to :product
    has_and_belongs_to_many :colors
    # accepts_nested_attributes_for :colors, :reject_if => lambda { |a| a[:title].blank? }, :allow_destroy => true

end
