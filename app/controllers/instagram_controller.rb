class InstagramController < ApplicationController

  def get_by_tag
    tag = params[:tag]
    instagram_service = InstagramService.new

    photos = Rails.cache.fetch("instagram-get-by-tag-#{tag}") do
      instagram_service.get_by_tag tag
    end

    render json: photos
  end

end
