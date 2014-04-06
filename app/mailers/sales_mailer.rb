class SalesMailer < ActionMailer::Base

  default from: 'info@builtbyswift.com'

  def success(email, guid)
    @guid = guid
    mail(to: email, subject: "Your order from Swift Industries")
  end

  def shipped sale
    @guid = sale.guid
    mail(to: sale.email, subject: "Your order from Swift Industries has shipped")
  end

end
