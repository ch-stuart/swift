module Flickr

    def get_photos_by_tag tag
        return Rails.cache.read(tag) if Rails.cache.exist?(tag)

        return [] if tag.blank?

        photos = []

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

            photo               = {}
            photo[:id]          = photo_info['id']
            photo[:description] = photo_info['description']
            photo[:title]       = photo_info['title']
            photo[:flickr_url]  = photo_info['urls'][0]['_content']
            # Get photo sizes
            photo_sizes         = flickr.photos.getSizes :photo_id => photo_info['id']

            # Get medium size photo
            medium_photo        = photo_sizes.find {|s| s.label == 'Medium' }

            # Don't proceed if we can't get a medium photo
            next if medium_photo.blank?

            # Save medium size photo info
            photo[:url]         = medium_photo.source
            photo[:height]      = medium_photo.height

            # Get large size photo
            large_photo = photo_sizes.find {|s| s.label == 'Large' }

            if large_photo.present?
                photo[:large_url]    = large_photo.source
                photo[:large_height] = large_photo.height
            else
                photo[:large_url]    = medium_photo.source
                photo[:large_height] = medium_photo.height
            end

            photos.push photo
        end

        Rails.cache.write(tag, photos)

        photos
    end

    def get_photo_by_id(id, size)
        return Rails.cache.read(id) if Rails.cache.exist?(id)

        return "" if id.blank?

        begin
            sizes = flickr.photos.getSizes :photo_id => id
        rescue Exception => e
            Rails.logger.info "Flickr.get_photo_by_id failed. #{e}"
            return ""
        end
        photo = sizes.find {|s| s.label == size }

        Rails.cache.write(id, photo.source)

        photo.source
    end

    def get_photos_by_set id
        return Rails.cache.read(id) if Rails.cache.exist?(id)

        photos = []

        results = flickr.photosets.getPhotos :photoset_id => id

        results["photo"].each do |photo|

            sizes = flickr.photos.getSizes :photo_id => photo["id"]
            medium = sizes.find {|size| size.label == "Medium" }
            photos.push({ :id => photo["id"], :url => medium.source })
        end

        if photos.length > 10
            photos = photos[0..9]
        end

        Rails.cache.write(id, photos)

        photos
    end

    def get_photos_by_user
        return Rails.cache.read('user_photos') if Rails.cache.exist?('user_photos')

        photos = []

        results = flickr.people.getPublicPhotos :user_id => APP_CONFIG['flickr_user_id'], :per_page => 10

        results.each do |photo|
            sizes = flickr.photos.getSizes :photo_id => photo.id
            medium = sizes.find {|s| s.label == 'Medium' }
            photos.push({ :id => photo.id, :url => medium.source })
        end

        Rails.cache.write('user_photos', photos)

        photos
    end

end
