class Page < ActiveRecord::Base

    validates_uniqueness_of :title, :path
    validates_format_of :path, :with =>  /^[a-zA-Z_-]+$/, :message => "Must be only alpha characters, or hyphens or underscores."

end
