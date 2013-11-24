class PagesController < ApplicationController

  before_filter :authenticate, :except => [ :show ]
  caches_action :show
  cache_sweeper ApplicationSweeper

  def index
    @pages = Page.all
    @subtitle = controller_name.titlecase
    render :layout => 'hub'
  end

  def show
    if params[:path]
      @page = Page.find_by_path(params[:path])
      render_404 if @page.nil?
    else
      @page = Page.find(params[:id])
    end

    @categories = Category.all
    @company    = Company.first
    @products   = Product.where(:status => 'Public', :kind => 'Product')
    @photos     = Page.get_photos_by_tag @page.flickr_tag
    @photo      = Page.get_photo_by_id(@page.flickr_photo, "Large")
    @video_html = @page.video_html
    @subtitle   = @page.title

    render_404 unless @page.public?
  end

  def new
    @page = Page.new
    @subtitle = "#{action_name.titlecase} Page"
  end

  def edit
    @page = Page.find(params[:id])
    @subtitle = "#{action_name.titlecase} `#{@page.title.titlecase}`"
  end

  def create
    @page = Page.new(params[:page])

    if @page.save
      redirect_to(@page, :notice => 'Page was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @page = Page.find(params[:id])

    if @page.update_attributes(params[:page])
      redirect_to(@page, :notice => 'Page was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    redirect_to(pages_url)
  end

end
