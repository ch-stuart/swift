class FlickrController < ApplicationController

  def get_by_id
    photos = FlickrService.get_by_id params[:id]

    render json: photos
  end

end
