class Part < ActiveRecord::Base

    belongs_to :product
    has_one :color

end
