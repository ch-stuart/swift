module ApplicationHelper

  def md text
    RDiscount.new(text).to_html
  end

end
