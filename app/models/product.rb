class Product < ActiveRecord::Base

  extend Flickr

  has_many :parts, :dependent => :destroy
  accepts_nested_attributes_for :parts, :reject_if => lambda { |a| a[:title].blank? }, :allow_destroy => true
  validates_uniqueness_of :title, :flickr_tag
  validates_format_of :flickr_tag, :with => /\A[A-Za-z0-9_\-]+\z/
  validates_format_of :price, :with => /\d{0,10}\.\d{2}/

  def public?
    return self.status == "Public"
  end

end

