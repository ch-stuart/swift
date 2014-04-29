class Contact < ActiveRecord::Base

    # who needs a duplicate email!
    validates_uniqueness_of :email

    attr_accessible :email, :archived
end
