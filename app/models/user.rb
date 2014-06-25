class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :failed_attempts, :unlock_token, :locked_at, :wholesale

  before_save :add_wholesale_if_user_is_preapproved

  private

  def add_wholesale_if_user_is_preapproved
    if PreApprovedDealer.find_by_email self.email
      self.wholesale = true
      UsersMailer.new_user(self.email, true).deliver
    else
      UsersMailer.new_user(self.email, false).deliver
    end
  end

end
