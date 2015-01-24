class SolsticeController < ApplicationController

  def index
    @company = Company.first
    @categories = Category.all
    @products = Product.where(status: "Public", kind: "Product")
  end

end
