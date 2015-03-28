class FlickrService

  require 'uri'

  def self.photo id, label
    Rails.cache.fetch("flickr-get-by-id-#{id}") do
      photo = {}
      info = flickr.photos.getInfo(photo_id: id)
      sizes = flickr.photos.getSizes(photo_id: id)

      size = sizes.select do |size|
        size["label"] == label
      end

      photo[:size] = size[0]
      photo[:title] = info["title"]
      photo[:url] = URI.extract(info["description"], ['http', 'https'])[0]

      photo.to_json
    end
  end

end
