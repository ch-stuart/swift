class Product < ActiveRecord::Base

  extend Flickr

  has_many :parts, :dependent => :destroy
  has_many :testimonials, :dependent => :destroy
  has_many :sizes, :dependent => :destroy
  accepts_nested_attributes_for :parts, :reject_if => lambda { |a| a[:title].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :testimonials, :reject_if => lambda { |a| a[:body].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :sizes, :reject_if => lambda { |a| a[:title].blank? }, :allow_destroy => true

  validates_presence_of :title, :short_title
  validates_uniqueness_of :title, :flickr_tag, :short_title
  validates_format_of :flickr_tag, :with => /\A[A-Za-z0-9_\-]+\z/
  validates_format_of :price, :with => /\d{0,10}\.\d{2}/

  def public?
    return self.status == "Public"
  end

end

