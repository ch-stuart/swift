class ApplicationController < ActionController::Base

  include CacheableFlash
  protect_from_forgery
  layout :resolve_layout
  before_filter :title
  helper_method :title

  def prime_flickr_cache
    public_products = Product.where(status: "Public")
    public_products_count = public_products.length

    Product.where(status: "Public").each_with_index do |product, index|
      logger.info "\n\n## Priming Flickr cache for #{product.title} (#{index + 1}/#{public_products_count})\n"

      if product.flickr_tag.present?
        FlickrCachePrimer.get_photos_by_tag product.flickr_tag
      end

      if product.flickr_set.present?
        FlickrCachePrimer.get_photos_by_set product.flickr_set
      end

      if product.flickr_photo.present?
        FlickrCachePrimer.get_photo_by_id product.flickr_photo
        FlickrCachePrimer.get_photo_by_id product.flickr_photo, "Medium"
        FlickrCachePrimer.get_photo_by_id product.flickr_photo, "Square"
      end
    end

    render text: "Yay"
  end

  protected

  def render_404
    raise ActionController::RoutingError.new("Not Found")
  end

  def title
    @title = Company.first.title
  end

  def verify_is_admin
    if current_user.try(:admin?)
      return
    else
      redirect_to root_url
    end
  end

  def resolve_layout
    Rails.logger.info controller_name
    if controller_name == "sessions"
      "devise"
    else
      case action_name
      when "new", "edit", "create", "update", "destroy"
        "hub"
      else
        "application"
      end
    end
  end

  def get_user_type
    return 'ADMIN'              if current_user.try(:admin?)
    return 'WHOLESALE'          if current_user.try(:wholesale?)
    return 'USER_SIGNED_IN'     if user_signed_in?
    return 'USER_NOT_SIGNED_IN'
  end
end
