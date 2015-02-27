class FlickrService

  def self.photo id, label
    Rails.cache.fetch("flickr-get-by-id-#{id}") do
      sizes = flickr.photos.getSizes(photo_id: id)

      size = sizes.select do |size|
        size["label"] == label
      end

      size[0].to_json
    end
  end

end
