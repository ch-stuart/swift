FlickRaw.api_key       = APP_CONFIG[:flickr_api_key]
FlickRaw.shared_secret = APP_CONFIG[:flickr_shared_secret]

# class FlickrCachePrimer
#   extend Flickr
# end
#
# public_products = Product.where(status: "Public")
# public_products_count = public_products.length
#
# Product.where(status: "Public").each_with_index do |product, index|
#   Rails.logger.info "\n\n## Priming Flickr cache for #{product.title} (#{index + 1}/#{public_products_count})\n"
#
#   if product.flickr_tag.present?
#     FlickrCachePrimer.get_photos_by_tag product.flickr_tag
#   end
#
#   if product.flickr_set.present?
#     FlickrCachePrimer.get_photos_by_set product.flickr_set
#   end
#
#   if product.flickr_photo.present?
#     FlickrCachePrimer.get_photo_by_id product.flickr_photo
#     FlickrCachePrimer.get_photo_by_id product.flickr_photo, "Medium"
#     FlickrCachePrimer.get_photo_by_id product.flickr_photo, "Square"
#   end
#
# end
