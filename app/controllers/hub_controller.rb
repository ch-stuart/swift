class HubController < ApplicationController

  before_filter :verify_is_admin
  layout "hub"

  def index
    @products = Product.all
    @pages = Page.all
    @colors = Color.all
    @company = Company.first
    @categories = Category.all
  end

  def expire_home_cache
      begin
        expire_action :controller => 'homes', :action => 'index', :user_type => 'WHOLESALE'
        expire_action :controller => 'homes', :action => 'index', :user_type => 'ADMIN'
        expire_action :controller => 'homes', :action => 'index', :user_type => 'USER_SIGNED_IN'
        expire_action :controller => 'homes', :action => 'index', :user_type => 'USER_NOT_SIGNED_IN'
        expire_fragment 'homes_index'
        redirect_to hub_path, notice: 'Home cache cleared.'
      rescue => e
        logger.info e
        redirect_to hub_path, alert: 'Home cache NOT cleared. Try again.'
      end
  end


  # Clear everything. Flickr is cached, so
  # if something updates over there we don't
  # know. Martina has to clear it manually.
  def expire_flickr_cache
    begin
      Rails.cache.clear
      redirect_to hub_path, notice: 'Flickr cache cleared.'
    rescue => e
      logger.info e
      redirect_to hub_path, alert: 'Flickr cache NOT cleared.'
    end
  end

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

    redirect_to hub_path, notice: 'Flickr cache primed.'
  end

end
