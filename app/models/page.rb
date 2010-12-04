class Page < ActiveRecord::Base
    validates_uniqueness_of :title, :path
end
