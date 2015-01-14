class CouponValidator < ActiveModel::Validator
  def validate(record)
    unless record.cents_off.present? || record.percent_off.present?
      record.errors[:cents_off] << 'Need a value for cents_off or percent_off'
      record.errors[:percent_off] << 'Need a value for cents_off or percent_off'
    end

    if record.cents_off.present? && record.percent_off.present?
      record.errors[:cents_off] << 'Choose one of cents_off or percent_off'
      record.errors[:percent_off] << 'Choose one of cents_off or percent_off'
    end

    if record.percent_off.present?
      if record.percent_off > 100
        record.errors[:percent_off] << 'Percent off must be below 101'
      end

      if record.percent_off < 1
        record.errors[:percent_off] << 'Percent off must be greater than 1'
      end
    end
  end
end

class Coupon < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with CouponValidator

  # Must have title and code
  validates :title, :code, presence: true

  # Cents off and percent off must be ints
  validates :cents_off, numericality: { only_integer: true }, if: :cents_off?
  validates :percent_off, numericality: { only_integer: true }, if: :percent_off?

  # Code and title must be unique
  validates :code, :title, :uniqueness => true

  # Code can only include good characters
  validates :code, format: { with: /\A[A-Za-z0-9_-]+\z/, message: "code can only contain letters, numbers, hyphens and underscores" }

  def is_invalid?
    return true unless self.published?

    now = Time.now

    if self.start_date.present?
      return true if now < start_date
    end

    if self.end_date.present?
      return true if now > end_date
    end

    return false
  end

end
