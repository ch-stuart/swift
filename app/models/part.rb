class Part < ActiveRecord::Base

    belongs_to :product
    has_and_belongs_to_many :colors
    accepts_nested_attributes_for :colors, :reject_if => lambda { |a| a[:title].blank? }, :allow_destroy => true
    validates_presence_of :title

    PRICE_MATCH = /^\d{0,10}\.\d{2}$/
    PRICE_MESSAGE = "must be in the following format: 12.00"
    validates_format_of :price, :with => PRICE_MATCH, :message => PRICE_MESSAGE, :if => :price?
    validates_format_of :wholesale_price, :with => PRICE_MATCH, :message => PRICE_MESSAGE, :if => :wholesale_price?

    def price_for is_wholesale_user
        is_wholesale_user ? self.wholesale_price : self.price
    end
    
end
