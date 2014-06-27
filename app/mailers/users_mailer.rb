class UsersMailer < ActionMailer::Base

  default from: 'info@builtbyswift.com'

  # Email customer when they've placed an order
  def new_user(email, preapproved)
    if preapproved
      body = "#{email} is pre-approved. <3 <3"
    else
      body = "#{email} is NOT pre-approved. :( :("
    end

    mail(
      to: "orders@builtbyswift.com",
      subject: "New user signed up: #{email}",
      body: body,
      content_type: "text/plain"
    )
  end

end
