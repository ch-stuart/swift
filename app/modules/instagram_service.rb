class InstagramService < SocialService

  def initialize
    @client = Instagram.client
  end

  def get_by_tag tag
    Rails.cache.fetch("instagram-get-by-tag-#{tag}") do
      medias = []

      media_items = @client.tag_recent_media(tag)

      media_items[0...4].each do |media_item|
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

  def prime_cache
    super self, "instagram-get-by-tag-bicycle"
  end

end
