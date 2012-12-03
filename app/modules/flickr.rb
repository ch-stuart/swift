module Flickr

    def get_photos_for_tag tag
        return {} if tag.blank?

        # http://snipplr.com/view/8954/create-nested-hashes/
        photos = Hash.new{|h,k| h[k]=Hash.new(&h.default_proc) }

        # This unforunately takes many calls to flickr in order to get the photo URLs
        # Say you have 5 photos in a slideshow
        # ... 1 call to get all of the tags
        # ... 5 more to get the sizes
        # ... 5 more to get the medium size photos
        # boo
        flickr.photos.search(:user_id => APP_CONFIG['flickr_user_id'], :tags => tag).each do |p|
            # Get photo info
            photo_info = flickr.photos.getInfo(:photo_id => p.id) # retrieve additional details
            # Save some photo info
            photos[p.id]['id']          = photo_info['id']
            photos[p.id]['description'] = photo_info['description']
            photos[p.id]['title']       = photo_info['title']
            photos[p.id]['flickr_url']  = photo_info['urls'][0]['_content']
            # Get photo sizes
            photo_sizes                 = flickr.photos.getSizes :photo_id => photo_info['id']
            # Get medium size photo
            medium_size_photo           = photo_sizes.find {|s| s.label == 'Medium' }
            # Save medium size photo info
            photos[p.id]['url']         = medium_size_photo.source
            photos[p.id]['height']      = medium_size_photo.height
        end

        photos
    end

    def get_photo_by_id(id, size)
        if Rails.cache.exist? id
            return Rails.cache.read id
        end

        return "" if id.blank?

        begin
            sizes = flickr.photos.getSizes :photo_id => id
        rescue Exception => e
            Rails.logger.info "Flickr.get_photo_by_id failed. #{e}"
            return ""
        end
        photo = sizes.find {|s| s.label == size }

        Rails.cache.write id, photo.source

        photo.source
    end
end
