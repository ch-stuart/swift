class ProductsMailer < ActionMailer::Base

  default from: 'info@builtbyswift.com'

  # Notify business when customer has placed an order
  def inventory_count_update product, size
    @product = product
    @size = size

    if size.present?
      count = @size.inventory_count
      @subject = "Inventory Update: \"#{@product.title}\", size \"#{@size.title}\" (#{count})"
    else
      count = @product.inventory_count
      @subject = "Inventory Update: \"#{@product.title}\" (#{count})"
    end

    if Rails.env == "production"
      mail(to: "orders@builtbyswift.com", subject: @subject)
    else
      mail(to: "charles.stuart@gmail.com", subject: @subject)
    end
  end

end
