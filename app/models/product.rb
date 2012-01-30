class Product < ActiveRecord::Base

  extend Flickr
  
  FLICKR_ID_MATCH = /^\d{10}$/
  
  KINDS = ["Product", "Accessory"]
  attr_reader :KINDS
  validates :kind, :inclusion => { :in => KINDS, :message => "%{value} is not a valid type" }
  
  STATUSES = ["Public", "Private"]
  attr_reader :STATUSES
  validates :status, :inclusion => { :in => STATUSES, :message => "%{value} is not a valid status" }

  has_many :parts, :dependent => :destroy
  has_many :testimonials, :dependent => :destroy
  has_many :sizes, :dependent => :destroy
  accepts_nested_attributes_for :parts, :reject_if => lambda { |a| a[:title].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :testimonials, :reject_if => lambda { |a| a[:body].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :sizes, :reject_if => lambda { |a| a[:title].blank? }, :allow_destroy => true

  validates_presence_of :title, :short_title, :price
  validates_uniqueness_of :title, :flickr_tag, :short_title
  validates_format_of :flickr_tag, :with => /^\A[A-Za-z0-9_\-]+\z$/
  validates_format_of :price, :with => /^\d{0,10}\.\d{2}$/, :message => "must be include dollars and cents, ex: 122.22"
  validates_format_of :flickr_photo, :with => FLICKR_ID_MATCH, :message => "is 10 digits long, all numbers.", :if => :flickr_photo?
  validates_format_of :flickr_illustration, :with => FLICKR_ID_MATCH, :message => "is 10 digits long, all numbers.", :if => :flickr_illustration?

  def public?
    return self.status == "Public"
  end

end

