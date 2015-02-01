class InstagramService

  def initialize
    @client = Instagram.client
  end

  def get_by_tag tag
    medias = []

    for media_item in @client.tag_recent_media(tag)
      medias.push({
        thumbnail: media_item.images.thumbnail.url,
        standard: media_item.images.standard_resolution.url,
        username: media_item.user.username,
        type: media_item.type,
        link: media_item.link,
        text: media_item.caption && media_item.caption.text ? media_item.caption.text : nil
      })
    end

    medias.to_json
  end

end
