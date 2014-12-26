class SizesController < ApplicationController

  before_filter :verify_is_admin
  # cache_sweeper ApplicationSweeper
  layout 'hub'

  def index
    @sizes = Size.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sizes }
    end
  end

  def show
    @size = Size.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @size }
    end
  end

  def new
    @size = Size.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @size }
    end
  end

  def edit
    @size = Size.find(params[:id])
  end

  def create
    @size = Size.new(params[:size])

    respond_to do |format|
      if @size.save
        format.html { redirect_to(@size, :notice => 'Size was successfully created.') }
        format.xml  { render :xml => @size, :status => :created, :location => @size }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @size.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @size = Size.find(params[:id])

    respond_to do |format|
      if @size.update_attributes(params[:size])
        format.html { redirect_to(@size, :notice => 'Size was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @size.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @size = Size.find(params[:id])
    @size.destroy

    respond_to do |format|
      format.html { redirect_to(sizes_url) }
      format.xml  { head :ok }
    end
  end
end
