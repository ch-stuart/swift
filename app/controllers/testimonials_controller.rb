# TODO remove format.xml

class TestimonialsController < ApplicationController

  before_filter :authenticate_admin
  cache_sweeper ApplicationSweeper
  layout 'hub'

  def index
    @testimonials = Testimonial.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @testimonials }
    end
  end

  def show
    @testimonial = Testimonial.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @testimonial }
    end
  end

  def new
    @testimonial = Testimonial.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @testimonial }
    end
  end

  def edit
    @testimonial = Testimonial.find(params[:id])
  end

  def create
    @testimonial = Testimonial.new(params[:testimonial])

    respond_to do |format|
      if @testimonial.save
        format.html { redirect_to(@testimonial, :notice => 'Testimonial was successfully created.') }
        format.xml  { render :xml => @testimonial, :status => :created, :location => @testimonial }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @testimonial.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @testimonial = Testimonial.find(params[:id])

    respond_to do |format|
      if @testimonial.update_attributes(params[:testimonial])
        format.html { redirect_to(@testimonial, :notice => 'Testimonial was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @testimonial.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @testimonial = Testimonial.find(params[:id])
    @testimonial.destroy

    respond_to do |format|
      format.html { redirect_to(testimonials_url) }
      format.xml  { head :ok }
    end
  end
end
