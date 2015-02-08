class InstagramController < ApplicationController

  def get_by_tag
    instagram_service = InstagramService.new
    photos = instagram_service.get_by_tag params[:tag]

    render json: photos
  end

end
