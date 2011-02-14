class Color < ActiveRecord::Base

    has_and_belongs_to_many :part
    validates_uniqueness_of :title, :hex
    
end
