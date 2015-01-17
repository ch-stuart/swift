class GiftCertificatesMailer < ActionMailer::Base

  default from: 'info@builtbyswift.com'

  helper :application

  # Notify business when customer has placed an order
  def notify_swift gift_certificate
    @gift_certificate = gift_certificate
    if Rails.env == "production"
      mail(to: "orders@builtbyswift.com", subject: "New gift certificate (#{gift_certificate.guid})")
    else
      mail(to: "webdev@builtbyswift.com", subject: "[#{Rails.env}] New gift certificate (#{gift_certificate.guid})")
    end
  end

end
