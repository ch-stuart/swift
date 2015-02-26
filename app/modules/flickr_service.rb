class FlickrService

  def self.get_by_id id
    Rails.cache.fetch("flickr-get-by-id-#{id}") do
      flickr.photos.getSizes(photo_id: id).to_json
    end
  end

end
