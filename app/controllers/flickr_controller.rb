class FlickrController < ApplicationController

  def photo
    photo = FlickrService.photo params[:id], params[:label]

    render json: photo
  end

end
