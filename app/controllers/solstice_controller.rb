class SolsticeController < ApplicationController

  def index
    @company = Company.first
    @categories = Category.all
    @products = Product.where(status: "Public", kind: "Product")
  end

  def share
    if current_user.blank?
      flash[:notice] = "You are not signed up for Swift Campout. Sign up to share."
      return redirect_to edit_user_registration_path
    end

    if current_user.camper.blank?
      flash[:notice] = "You are not signed in. Sign in to share."
      return redirect_to new_user_session_path
    end

    # TODO verify user has camper association?

    current_user.camper.is_public = true
    current_user.save

    flash[:notice] = "You have successfully shared your camper profile"
    redirect_to swiftcampout_path
  end

end
