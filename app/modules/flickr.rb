module Flickr

  def get_photos_for_tag obj
    return [] if obj.flickr_tag.nil?
    return [] if obj.flickr_tag.empty?

    Rails.logger.info "=> get_photos_for_tag"

    # http://snipplr.com/view/8954/create-nested-hashes/
    photos = Hash.new{|h,k| h[k]=Hash.new(&h.default_proc) }
    flickr.photos.search(:user_id => APP_CONFIG['flickr_user_id'], :tags => obj.flickr_tag).each do |p|

      Rails.logger.info "=> get_photos_for_tag: flickr.photos.search"

      info = flickr.photos.getInfo(:photo_id => p.id) # retrieve additional details

      photos[p.id]['id'] = info['id']
      photos[p.id]['description'] = info['description']
      photos[p.id]['title'] = info['title']
      photos[p.id]['flickr_url'] = info['urls'][0]['_content']
      photos[p.id]['square_thumb'] = FlickRaw.url_s(info)

      # flickraw doesn't provide an url helper for the largest available size, so get it the long way
      sizes = flickr.photos.getSizes :photo_id => p.id
      large_info = sizes.find {|s| s.label == 'Medium 640' }

      unless large_info.nil?
        photos[p.id]['large'] = large_info.source
        # get the width and height so we can put the sizes on the <img> tag
        photos[p.id]['large_width'] = large_info.width
        photos[p.id]['large_height'] = large_info.height
      else

      end

      # photos[p.id]['thumb'] = FlickRaw.url_t(info)
      # photos[p.id]['medium'] = FlickRaw.url_m(info)
      # photos[p.id]['large'] = FlickRaw.url(info)
    end
    return photos
  end

  def get_photo_by_id id
    return "" if id.nil?

    sizes = flickr.photos.getSizes :photo_id => id
    medium_640 = sizes.find do |size|
      size.label == 'Medium 640'
    end
    medium_640.source
  end

end

