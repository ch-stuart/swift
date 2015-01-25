class ColorsController < ApplicationController

  before_filter :verify_is_admin
  cache_sweeper ApplicationSweeper
  layout "hub"

  def index
    @colors = Color.all
  end

  def show
    @color = Color.find(params[:id])
  end

  def new
    @color = Color.new
  end

  def edit
    @color = Color.find(params[:id])
  end

  def create
    @color = Color.new(color_params)

    if @color.save
      redirect_to(@color, :notice => 'Color was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @color = Color.find(params[:id])

    if @color.update_attributes(color_params)
      redirect_to(@color, :notice => 'Color was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @color = Color.find(params[:id])
    @color.destroy

    redirect_to(colors_url)
  end

  private

  def color_params
    params.require(:color).permit(:title, :hex, :price, :wholesale_price)
  end
end
