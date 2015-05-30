module Flickr

  # url_s : Square
  # url_q : Large Square
  # url_t : Thumbnail
  # url_m : Small
  # url_n : Small 320
  # url   : Medium
  # url_z : Medium 640
  # url_c : Medium 800
  # url_b : Large
  # url_o : Original

  def get_photos_by_tag tag
    Rails.logger.info "Flickr#get_photos_by_tag: #{tag}"
    start = Time.now

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

    flickr.photos.search(
      user_id: APP_CONFIG[:flickr_user_id],
      tags: URI.escape(tag),
      extras: "description, owner_name, url_z, url_b"
    ).each do |p|

      # Save some photo info
      photo               = {}
      photo[:id]          = p['id']
      photo[:description] = p['description']
      photo[:title]       = p['title']
      # https://www.flickr.com/photos/swiftpanniers/14973750878/
      photo[:flickr_url]  = "https://www.flickr.com/photos/#{p['owner_name']}/#{p['id']}"

      # Don't proceed if we can't get a medium photo
      if p['url_z'].blank?
        Rails.logger.warn "Flickr#get_photos_by_tag: Cannot get medium sized photo. Skipping."
        next
      end

      # Save medium size photo info
      photo[:url]         = p['url_z']
      photo[:height]      = p['height_z']

      if p['url_b'].present?
        photo[:large_url]    = p['url_b']
        photo[:large_height] = p['height_b']
      else
        Rails.logger.warn "Flickr#get_photos_by_tag: Could not get large photo. Using medium photo instead."
        photo[:large_url]    = photo[:url]
        photo[:large_height] = photo[:height]
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

    Rails.logger.info "--> Flickr#get_photos_by_tag #{Time.now - start}s"

    photos
  end

  def get_photo_by_id(id, size=nil)
    Rails.logger.info "Flickr#get_photos_by_id #{id}"
    start = Time.now

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
      sizes = flickr.photos.getSizes photo_id: id
    rescue Exception => e
      Rails.logger.info "Flickr.get_photo_by_id failed. #{e}"
      return ""
    end

    if size
      photo = sizes.find {|s| s.label == size }
    else
      %w{Large Medium Small Thumbnail}.each do |imgSize|
        photo = sizes.find {|s| s.label == imgSize }
        break unless photo.nil?
      end
    end

    Rails.cache.write(cache_key, photo.source)

    Rails.logger.info "--> Flickr#get_photo_by_id #{Time.now - start}s"

    photo.source.gsub("http:", "")
  end

  def get_photos_by_set id
    Rails.logger.info "Flickr#get_photos_by_set #{id}"
    start = Time.now

    if id.blank?
      return []
    else
      if Rails.cache.exist?(id) && Rails.cache.read(id).present?
        return Rails.cache.read(id)
      end
    end

    photos = []

    results = flickr.photosets.getPhotos(photoset_id: id, extras: "url_n, url_z", per_page: 10)

    results["photo"].each do |p|

      next if p["url_n"].blank?
      next if p["url_z"].blank?

      photos.push({
        id: p["id"],
        small_320_url: p["url_n"],
        medium_640_url: p["url_z"]
      })
    end

    Rails.cache.write(id, photos)

    Rails.logger.info "--> Flickr#get_photos_by_set #{Time.now - start}s"

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
