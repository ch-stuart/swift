class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable

  after_create :add_wholesale_if_user_is_preapproved
  after_create :email_if_attending_campout_in_2015

  geocoded_by :address
  after_validation :geocode

  def address
    address = []

    address.push(self.line1) if self.line1.present?
    address.push(self.line2) if self.line2.present?
    address.push(self.city) if self.city.present?
    address.push(self.state) if self.state.present?
    address.push(self.zip_code) if self.zip_code.present?
    address.push(self.country) if self.country.present?

    address.join(", ")
  end

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
