class PagesController < ApplicationController

  before_filter :verify_is_admin, :except => [ :show ]

  caches_action :show, :cache_path => Proc.new { |c|
    { 'user_type' => get_user_type }
  }

  def index
    @public_pages = Page.where(status: "Public")
    @private_pages = Page.where(status: "Private")
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

    @photos     = Page.get_photos_by_tag @page.flickr_tag
    @video_html = @page.video_html
    @subtitle   = @page.title

    if @page.flickr_photo.present?
      @photo = Page.get_photo_by_id(@page.flickr_photo)
    else
      @photo = nil
    end

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
    @page = Page.new(page_params)

    if @page.save
      redirect_to(@page, :notice => 'Page was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @page = Page.find(params[:id])

    if @page.update_attributes(page_params)
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

  private

  def page_params
    params
      .require(:page)
      .permit(
        :title,
        :body,
        :path,
        :status,
        :video_html,
        :flickr_tag,
        :featured,
        :summary,
        :show_video_on_homepage,
        :show_photo_on_homepage,
        :flickr_photo,
        :hide_title_on_homepage,
        :hide_read_more_link_on_homepage,
        :include_in_about_us_navigation
      )
  end

end
