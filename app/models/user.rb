class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable

  has_one :camper, dependent: :destroy
  accepts_nested_attributes_for :camper, :reject_if => :all_blank

  validates :contact, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true
  # Devise already validates email
  # validates :email, presence: true, uniqueness: true, length: { maximum: 200 }

  after_create :add_wholesale_if_user_is_preapproved
  after_create :email_if_attending_campout_in_2015

  after_save :clear_campout_locations_cache

  geocoded_by :address
  after_validation :geocode

  def address
    address = []

    address.push(self.line1)    if self.line1.present?
    address.push(self.line2)    if self.line2.present?
    address.push(self.city)     if self.city.present?
    address.push(self.state)    if self.state.present?
    address.push(self.zip_code) if self.zip_code.present?
    address.push(self.country)  if self.country.present?

    address.join(", ")
  end

  def is_camper?
    self.is_attending_campout_in_2015
  end

  def is_not_camper?
    !self.is_attending_campout_in_2015
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

    UsersMailer.new_camper_for_2015(user).deliver_now
  end

  def clear_campout_locations_cache
    Rails.logger.debug "Clearing cache for camper locations"
    Rails.cache.delete "users_campout_locations"
  end

end
