class SalesMailer < ActionMailer::Base

  default from: 'info@builtbyswift.com'

  def success(email, guid)
    @company = Company.first
    @guid = guid
    mail(to: email, subject: "Your order from Swift Industries")
  end

end
