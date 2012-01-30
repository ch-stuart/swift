class Part < ActiveRecord::Base

    belongs_to :product
    has_and_belongs_to_many :colors
    accepts_nested_attributes_for :colors, :reject_if => lambda { |a| a[:title].blank? }, :allow_destroy => true
    validates_presence_of :title
    validates_format_of :price, :with => /^\d{0,10}\.\d{2}$/, :message => "must be include dollars and cents, ex: 122.22", :if => :price?
    
end
