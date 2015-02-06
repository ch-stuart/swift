class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable

  before_create :add_wholesale_if_user_is_preapproved

  private

  def add_wholesale_if_user_is_preapproved
    if PreApprovedDealer.find_by_email self.email
      self.wholesale = true
      UsersMailer.new_user(self.email, true).deliver_now
    else
      UsersMailer.new_user(self.email, false).deliver_now
    end
  end

end
