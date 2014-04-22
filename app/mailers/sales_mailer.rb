class SalesMailer < ActionMailer::Base

  default from: 'info@builtbyswift.com'

  def success(email, guid)
    @guid = guid
    mail(to: email, subject: "Your order from Swift Industries")
  end

  def shipped sale, shipment
    @sale = sale
    @shipment = shipment
    mail(to: sale.email, subject: "Your order from Swift Industries has shipped")
  end

  def ready_for_pickup sale
    @sale = sale
    mail(to: sale.email, subject: "Your order from Swift Industries is read for pickup")
  end

end
