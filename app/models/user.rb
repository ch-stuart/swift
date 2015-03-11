class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable

  after_create :add_wholesale_if_user_is_preapproved
  after_create :email_if_attending_campout_in_2015

  private

  def add_wholesale_if_user_is_preapproved
    user = User.find_by_email self.email

    if PreApprovedDealer.find_by_email self.email
      self.wholesale = true
      self.is_pending_wholesale = false
      user.save!
      UsersMailer.new_user(user: user, preapproved: true).deliver_now
    else
      UsersMailer.new_user(user: user, preapproved: false).deliver_now
    end
  end

  def email_if_attending_campout_in_2015
    user = User.find_by_email self.email

    return unless self.is_attending_campout_in_2015

    UsersMailer.new_camper_for_2015(user: user).deliver_now
  end

end
