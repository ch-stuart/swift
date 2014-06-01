class JavascriptExceptionMailer < ActionMailer::Base

  default from: 'info@builtbyswift.com'

  def report(msg)
    mail(
      to: "charles.stuart@gmail.com",
      subject: "JavaScript Exception at builtbyswift.com",
      body: msg,
      content_type: "text/plain"
    )
  end

end
