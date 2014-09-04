class Product < ActiveRecord::Base

  extend Flickr

  attr_accessible :title, :description, :flickr_tag, :specs, :status, :price, :kind,
  :short_title, :humane_price, :flickr_photo, :question, :answer, :not_for_sale,
  :not_for_sale_message, :featured_on_homepage, :flickr_set, :short_description,
  :wholesale_humane_price, :wholesale_price, :width, :height, :length, :weight,
  :package_type, :sizes_attributes, :parts_attributes, :category_id, :testimonials_attributes,
  :related_products

  has_many :parts, :dependent => :destroy
  has_many :testimonials, :dependent => :destroy
  has_many :sizes, :dependent => :destroy
  belongs_to :category

  accepts_nested_attributes_for :parts, :reject_if => lambda { |a| a[:title].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :testimonials, :reject_if => lambda { |a| a[:body].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :sizes, :reject_if => lambda { |a| a[:title].blank? }, :allow_destroy => true

  FLICKR_ID_MATCH = /^\d{10,11}$/
  FLICKR_SET_MATCH = /^\d{17}$/

  KINDS = ["Product", "Accessory", "Stock", "Gift Certificate"]
  attr_reader :KINDS
  validates :kind, :inclusion => { :in => KINDS, :message => "%{value} is not a valid type" }

  PACKAGE_TYPE = ["CUSTOM", "LETTER", "PAK"]
  attr_reader :PACKAGE_TYPE
  validates :package_type, :inclusion => { :in => PACKAGE_TYPE, :message => "%{value} is not a valid type" }

  STATUSES = ["Public", "Private"]
  attr_reader :STATUSES
  validates :status, :inclusion => { :in => STATUSES, :message => "%{value} is not a valid status" }

  validates_presence_of :title, :short_title, :flickr_tag, :flickr_photo, :price, :humane_price, :wholesale_price, :wholesale_humane_price
  # Accessories and Stock cannot have categories, otherwise they show up in the
  # home page navigation categories.
  validates_presence_of :category_id, :if => :is_product?

  validates_uniqueness_of :title, :short_title
  validates_format_of :flickr_tag, :with => /\A[A-Za-z0-9_\-]+\z/, :if => :flickr_tag?
  validates_format_of :flickr_photo, :with => FLICKR_ID_MATCH, :message => "is 10 digits long, all numbers.", :if => :flickr_photo?
  validates_format_of :flickr_set, :with => FLICKR_SET_MATCH, :message => "is 17 digits long, all numbers.", :if => :flickr_set?

  PRICE_MATCH = /\A\d{0,10}\.\d{2}\z/
  PRICE_MESSAGE = "must be in the following format: 12.00"
  validates_format_of :price, :with => PRICE_MATCH, :message => PRICE_MESSAGE, :if => :price?
  validates_format_of :wholesale_price, :with => PRICE_MATCH, :message => PRICE_MESSAGE, :if => :wholesale_price?

  before_save :serialize_related_products

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

  def humane_price_for current_user
    current_user.try(:wholesale?) ? self.wholesale_humane_price : self.humane_price
  end

  private

  def serialize_related_products
    if self.related_products.present?
      self.related_products = related_products.to_json
    end
  end

end
