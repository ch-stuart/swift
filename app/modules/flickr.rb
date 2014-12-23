module Flickr

  def get_photos_by_tag tag
    Rails.logger.info "Flickr#get_photos_by_tag: #{tag}"

    # return [] if not tag
    if tag.blank?
      Rails.logger.warn "Flickr#get_photos_by_tag: Tag is blank. Returning empty array"
      return []
    else
      # check for photos in cache if tag is present
      if Rails.cache.exist?(tag) && Rails.cache.read(tag).present?
        Rails.logger.info "Flickr#get_photos_by_tag: Using cached result"
        Rails.logger.info "#{Rails.cache.read(tag)}"
        return Rails.cache.read(tag)
      else
        Rails.logger.info "Flickr#get_photos_by_tag: No cached result available"
      end
    end

    # go get them if they are not cached
    photos = []

    # This unforunately takes many calls to flickr in order to get the photo URLs
    # Say you have 5 photos in a slideshow
    # ... 1 call to get all of the tags
    # ... 5 more to get the sizes
    # ... 5 more to get the medium size photos
    # boo
    flickr.photos.search(:user_id => APP_CONFIG[:flickr_user_id], :tags => URI.escape(tag)).each do |p|
      # Rails.logger.info "Flickr#get_photos_by_tag: Photo returned: #{p.inspect}"

      # Get photo info
      photo_info = flickr.photos.getInfo(:photo_id => p.id) # retrieve additional details

      # Save some photo info
      photo               = {}
      photo[:id]          = photo_info['id']
      photo[:description] = photo_info['description']
      photo[:title]       = photo_info['title']
      photo[:flickr_url]  = photo_info['urls'][0]['_content'].gsub("http:", "")
      # Get photo sizes
      photo_sizes         = flickr.photos.getSizes :photo_id => photo_info['id']

      # Get medium size photo
      medium_photo        = photo_sizes.find {|s| s.label == 'Medium' }

      # Don't proceed if we can't get a medium photo
      if medium_photo.blank?
        Rails.logger.warn "Cannot get medium sized photo. Skipping."
        next
      end

      # Save medium size photo info
      photo[:url]         = medium_photo.source.gsub("http:", "")
      photo[:height]      = medium_photo.height

      # Get large size photo
      large_photo = photo_sizes.find {|s| s.label == 'Large' }

      if large_photo.present?
        photo[:large_url]    = large_photo.source.gsub("http:", "")
        photo[:large_height] = large_photo.height
      else
        Rails.logger.warn "Could not get large photo. Using medium photo instead."
        photo[:large_url]    = medium_photo.source.gsub("http:", "")
        photo[:large_height] = medium_photo.height
      end

      photos.push photo
    end

    if photos.empty?
      # Test this
      # ExceptionNotifier.notify_exception(
      #   { :tag => tag },
      #   :env => request.env,
      #   :data => { :message => "Flickr#get_photos_by_tag returned no results" }
      # )
    end

    Rails.cache.write(tag, photos)

    photos
  end

  def get_photo_by_id(id, size=nil)
    Rails.logger.info "Flickr#get_photos_by_id #{id}"

    if size.nil?
      cache_key = "#{id}-nothing"
    else
      cache_key = "#{id}-#{size}"
    end

    if id.blank?
      return ""
    else
      if Rails.cache.exist?(cache_key) && Rails.cache.read(cache_key).present?
        return Rails.cache.read(cache_key)
      end
    end

    begin
      sizes = flickr.photos.getSizes :photo_id => id
    rescue Exception => e
      Rails.logger.info "Flickr.get_photo_by_id failed. #{e}"
      return ""
    end

    if size
      photo = sizes.find {|s| s.label == size }
    else
      %w{Large Medium Small Thumbnail}.each do |size|
        photo = sizes.find {|s| s.label == size }
        break unless photo.nil?
      end
    end

    Rails.cache.write(cache_key, photo.source)

    photo.source.gsub("http:", "")
  end

  def get_photos_by_set id
    Rails.logger.info "Flickr#get_photos_by_set #{id}"

    if id.blank?
      return []
    else
      if Rails.cache.exist?(id) && Rails.cache.read(id).present?
        return Rails.cache.read(id)
      end
    end

    photos = []

    results = flickr.photosets.getPhotos :photoset_id => id

    results["photo"].each do |photo|
      sizes = flickr.photos.getSizes :photo_id => photo["id"]

      medium_800 = sizes.find {|size| size.label == "Medium 800" }
      medium_640 = sizes.find {|size| size.label == "Medium 640" }
      medium = sizes.find {|size| size.label == "Medium" }
      small_320 = sizes.find {|size| size.label == "Small 320" }

      photos.push({
        id: photo["id"],
        small_320_url: small_320.source,
        # medium_url: medium.source,
        # url: medium.source,
        medium_640_url: medium_640.source
        # medium_800_url: medium_800.source
      })
    end

    if photos.length > 10
      photos = photos[0..9]
    end

    Rails.cache.write(id, photos)

    photos
  end

  # # NOT USED
  # def get_photos_by_user
  #   return Rails.cache.read('user_photos') if Rails.cache.exist?('user_photos')
  #
  #   photos = []
  #
  #   results = flickr.people.getPublicPhotos :user_id => APP_CONFIG[:flickr_user_id], :per_page => 10
  #
  #   results.each do |photo|
  #     sizes = flickr.photos.getSizes :photo_id => photo.id
  #     medium = sizes.find {|s| s.label == 'Medium' }
  #     photos.push({ :id => photo.id, :url => medium.source })
  #   end
  #
  #   Rails.cache.write('user_photos', photos)
  #
  #   photos
  # end

end
