class InstagramController < ApplicationController

  def get_by_tag
    client = Instagram.client
    photos = []

    for media_item in client.tag_recent_media(params[:tag])
      photos.push({
        thumbnail: media_item.images.thumbnail.url,
        standard: media_item.images.standard_resolution.url,
        username: media_item.user.username
      })
    end

    render json: photos
  end

end
