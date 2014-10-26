class ProductsMailer < ActionMailer::Base

  default from: 'info@builtbyswift.com'

  # Notify business when customer has placed an order
  def inventory_count_update product
    @product = product
    if Rails.env == "production"
      mail(to: "orders@builtbyswift.com", subject: "Inventory Update: \"#{@product.title}\" (#{@product.inventory_count})")
    else
      mail(to: "charles.stuart@gmail.com", subject: "Inventory Update: \"#{@product.title}\" (#{@product.inventory_count})")
    end
  end

end
