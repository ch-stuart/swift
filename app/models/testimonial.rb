class Testimonial < ActiveRecord::Base

    belongs_to :product
    validates_presence_of :body, :author

    attr_accessible :body, :author, :product_id

end
