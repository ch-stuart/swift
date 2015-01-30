class InstagramService

  def initialize
    @client = Instagram.client
  end

  def get_by_tag tag
    photos = []

    for media_item in @client.tag_recent_media(tag)
      photos.push({
        thumbnail: media_item.images.thumbnail.url,
        standard: media_item.images.standard_resolution.url,
        username: media_item.user.username
      })
    end

    photos.to_json
  end

end
