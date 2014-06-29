class UsersController < ApplicationController

  before_filter :verify_is_admin, except: [:my_info, :edit_my_info, :update]
  layout "hub", except: [:my_info, :edit_my_info]

  def index
    @dealers = User.where(wholesale: true)
    @admins = User.where(admin: true)
    @users = User.where(admin: false, wholesale: false)
  end

  def edit
    @user = User.find params[:id]
  end

  def my_info
    @company = Company.first
    @categories = Category.all
    @products = Product.where(:status => 'Public', :kind => 'Product')

    @user = User.find params[:id]
  end

  def edit_my_info
    @company = Company.first
    @categories = Category.all
    @products = Product.where(:status => 'Public', :kind => 'Product')

    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]

    # Don't allow dealer to update anything that they're
    # not supposed to.
    unless current_user.try(:admin?)
      logger.info "Whitelisting inputs for dealer"
      copy = params[:user]
      params[:user] = {}
      params[:user][:line1]       = copy[:line1]
      params[:user][:city]        = copy[:city]
      params[:user][:state]       = copy[:state]
      params[:user][:zip_code]    = copy[:zip_code]
      params[:user][:country]     = copy[:country]
      params[:user][:phone_no]    = copy[:phone_no]
      params[:user][:company]     = copy[:company]
      params[:user][:company_url] = copy[:company_url]
      params[:user][:contact]     = copy[:contact]
      logger.info params[:user]
    end

    respond_to do |format|
      if @user.update_attributes(params[:user])
        if current_user.try(:admin?)
          format.html { redirect_to users_url, :notice => 'User was successfully updated.' }
        else
          format.html { redirect_to my_info_path(@user), :notice => '"My Info" was successfully updated.' }
        end
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find params[:id]
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end

end
