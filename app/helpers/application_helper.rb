module ApplicationHelper

  def md text
    RDiscount.new(text).to_html
  end

  def digest str
    Digest::MD5.hexdigest str
  end

end
