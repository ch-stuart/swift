class InstagramController < ApplicationController

  def get_by_tag
    tag = params[:tag]
    client = Instagram.client
    photos = []

    @photos = Rails.cache.fetch("instagram-get-by-tag-#{tag}") do
      for media_item in client.tag_recent_media(params[:tag])
        photos.push({
          thumbnail: media_item.images.thumbnail.url,
          standard: media_item.images.standard_resolution.url,
          username: media_item.user.username
        })
      end

      photos.to_json
    end



    render json: @photos
  end

end
