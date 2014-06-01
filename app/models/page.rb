class Page < ActiveRecord::Base

  extend Flickr

  validates_uniqueness_of :path
  validates_presence_of :title, :path
  validates_format_of :path, :with =>  /\A[a-zA-Z_-]+\z/, :message => "Must be only alpha characters, or hyphens or underscores."

  attr_accessible :title, :body, :path, :status, :video_html, :flickr_tag, :featured, :summary, :show_video_on_homepage, :show_photo_on_homepage, :flickr_photo, :hide_title_on_homepage, :hide_read_more_link_on_homepage

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
