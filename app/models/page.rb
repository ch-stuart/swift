class Page < ActiveRecord::Base

  extend Flickr

  validates_uniqueness_of :path
  validates_presence_of :title, :path
  validates_format_of :path, :with =>  /^[a-zA-Z_-]+$/, :message => "Must be only alpha characters, or hyphens or underscores."

  def public?
    self.status == "Public"
  end

  def featured?
    self.status == "Featured"
  end

end
