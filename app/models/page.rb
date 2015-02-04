class Page < ActiveRecord::Base

  extend Flickr

  validates_uniqueness_of :path
  validates_presence_of :title, :path
  validates_format_of :path, :with =>  /\A[a-zA-Z_-]+\z/, :message => "Must be only alpha characters, or hyphens or underscores."

  scope :about_us_nav, -> { where(include_in_about_us_navigation: true, status: "Public") }
  scope :featured_pages, -> { where(featured: "Featured", status: "Public").reverse }

  def public?
    self.status == "Public"
  end

  def private?
    self.status == "Private"
  end

  def featured?
    self.featured == "Featured"
  end

end
