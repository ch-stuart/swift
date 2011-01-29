class Product < ActiveRecord::Base

    has_many :parts
    
    def self.get_photos_for_tag product
        # http://snipplr.com/view/8954/create-nested-hashes/
        photos = Hash.new{|h,k| h[k]=Hash.new(&h.default_proc) }
        flickr.photos.search(:user_id => APP_CONFIG['flickr_user_id'], :tags => product.flickr_tag).each do |p|
            info = flickr.photos.getInfo(:photo_id => p.id) # retrieve additional details
            
            photos[p.id]['title'] = info['title']
            photos[p.id]['flickr_url'] = info['urls'][0]['_content']
            photos[p.id]['thumb'] = FlickRaw.url_t(info)
            photos[p.id]['square_thumb'] = FlickRaw.url_s(info)
            photos[p.id]['medium'] = FlickRaw.url_m(info)
            photos[p.id]['large'] = FlickRaw.url(info)
        end
        return photos
    end

    def public?
      return self.status == "Public"
    end


    validates_uniqueness_of :title, :flickr_tag
    validates_format_of :flickr_tag, :with => /\A[A-Za-z0-9_\-]+\z/
    validates_format_of :price, :with => /\d{0,10}\.\d{2}/
end
