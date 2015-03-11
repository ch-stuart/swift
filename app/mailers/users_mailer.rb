class UsersMailer < ActionMailer::Base

  default from: 'info@builtbyswift.com'

  # Email swift when a new user registers
  def new_user opts
    lines = []
    lines.push "email: #{opts[:user].email}"
    lines.push "link: https://www.builtbyswift.com/users/#{opts[:user].id}"

    subject = "Users: New User"

    if opts[:user].is_attending_campout_in_2015?
      subject = "Users: New Swift Campout Registration"
    end

    if opts[:user].is_pending_wholesale?
      subject = "Users: New Dealer Registration"
    end

    if opts[:user].wholesale?
      subject = "Users: New Pre-approved Dealer Registration"
    end

    mail(
      to: "orders@builtbyswift.com",
      subject: subject,
      body: lines.join("\n"),
      content_type: "text/plain"
    )
  end

  def new_camper_for_2015 user
    mail(to: user.email, subject: "Thanks for joining Swift Campout!")
  end

end
