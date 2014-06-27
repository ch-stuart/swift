class UsersController < ApplicationController

  before_filter :verify_is_admin
  layout "hub"

  def index
    @dealers = User.where(wholesale: true)
    @admins = User.where(admin: true)
    @users = User.where(admin: false, wholesale: false)
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to users_url, :notice => 'User was successfully updated.' }
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
