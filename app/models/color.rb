class Color < ActiveRecord::Base

    has_and_belongs_to_many :part
    validates_uniqueness_of :title, :hex
    validates_presence_of :title, :hex
    validates :hex, :hex_color => true
    validates_format_of :price, :with => /^\d{0,10}\.\d{2}$/, :message => "must be include dollars and cents, ex: 35.00", :if => :price?
    
end
