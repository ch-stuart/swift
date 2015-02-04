class Testimonial < ActiveRecord::Base

    belongs_to :product, touch: true
    validates_presence_of :body, :author

end
