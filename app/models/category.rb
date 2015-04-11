class Category < ActiveRecord::Base

    acts_as_list
    default_scope { order('position ASC') }

    has_many :products

end
