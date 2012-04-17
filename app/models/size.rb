class Size < ActiveRecord::Base

    belongs_to :product
    validates_presence_of :title
    validates_format_of :price, :with => /^\d{0,10}\.\d{2}$/, :message => "must be include dollars and cents, ex: 12.00", :if => :price?

end
