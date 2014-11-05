class SalesMailer < ActionMailer::Base

  default from: 'info@builtbyswift.com'

  # Email customer when they've placed an order
  def success(email, guid)
    @guid = guid
    mail(to: email, subject: "Your order from Swift Industries")
  end

  # Notify business when customer has placed an order
  def notify_swift sale
    @sale = sale
    if Rails.env == "production"
      mail(to: "orders@builtbyswift.com", subject: "New order from #{sale.email} (#{sale.guid})")
    else
      mail(to: "orders@builtbyswift.com", cc: "charles.stuart@gmail.com", subject: "New order from #{sale.email} (#{sale.guid})")
    end
  end

  # Notify customer when order has been shipped
  def shipped sale, shipment
    @sale = sale
    @shipment = shipment
    mail(to: sale.email, subject: "Your order from Swift Industries has shipped")
  end

  # Notify customer when order has been shipped
  def shipped_flat_rate sale
    @sale = sale
    mail(to: sale.email, subject: "Your order from Swift Industries has shipped")
  end

  # Notify customer when order is ready to be picked up
  def ready_for_pickup sale
    @sale = sale
    mail(to: sale.email, subject: "Your order from Swift Industries is read for pickup")
  end

end
