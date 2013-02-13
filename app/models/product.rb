class Product < ActiveRecord::Base

  extend Flickr
  
  has_many :parts, :dependent => :destroy
  has_many :testimonials, :dependent => :destroy
  has_many :sizes, :dependent => :destroy
  belongs_to :category

  accepts_nested_attributes_for :parts, :reject_if => lambda { |a| a[:title].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :testimonials, :reject_if => lambda { |a| a[:body].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :sizes, :reject_if => lambda { |a| a[:title].blank? }, :allow_destroy => true

  FLICKR_ID_MATCH = /^\d{10}$/
  FLICKR_SET_MATCH = /^\d{17}$/
  
  KINDS = ["Product", "Accessory", "Stock"]
  attr_reader :KINDS
  validates :kind, :inclusion => { :in => KINDS, :message => "%{value} is not a valid type" }
  
  STATUSES = ["Public", "Private"]
  attr_reader :STATUSES
  validates :status, :inclusion => { :in => STATUSES, :message => "%{value} is not a valid status" }

  validates_presence_of :title, :short_title, :flickr_tag, :flickr_photo, :price
  # Accessories and Stock cannot have categories, otherwise they show up in the
  # home page navigation categories.
  validates_presence_of :category_id, :if => :is_product?

  validates_uniqueness_of :title, :short_title
  validates_format_of :flickr_tag, :with => /^\A[A-Za-z0-9_\-]+\z$/, :if => :flickr_tag?
  validates_format_of :price, :with => /^\d{0,10}\.\d{2}$/, :message => "must be include dollars and cents, ex: 122.22"
  validates_format_of :flickr_photo, :with => FLICKR_ID_MATCH, :message => "is 10 digits long, all numbers.", :if => :flickr_photo?
  validates_format_of :flickr_set, :with => FLICKR_SET_MATCH, :message => "is 10 digits long, all numbers.", :if => :flickr_set?

  def public?
    self.status == "Public"
  end

  def is_accessory?
    self.kind == "Accessory"
  end
  
  def is_stock?
    self.kind == "Stock"
  end
  
  def is_product?
    self.kind == "Product"
  end

  def is_not_for_sale?
    self.not_for_sale == true
  end

end

