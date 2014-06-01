class Size < ActiveRecord::Base

    belongs_to :product
    validates_presence_of :title

    PRICE_MATCH = /^\d{0,10}\.\d{2}$/
    PRICE_MESSAGE = "must be in the following format: 12.00"
    validates_format_of :price, :with => PRICE_MATCH, :message => PRICE_MESSAGE, :if => :price?
    validates_format_of :wholesale_price, :with => PRICE_MATCH, :message => PRICE_MESSAGE, :if => :wholesale_price?

    attr_accessible :title, :price, :product_id, :wholesale_price

    def price_for is_wholesale_user
        is_wholesale_user ? self.wholesale_price : self.price
    end

end
