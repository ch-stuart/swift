module ApplicationHelper

    def md text
        RDiscount.new(text).to_html
    end

    def set_column_classes length
        num = "four"
        num = "three" if length > 4

        "#{num} columns"
    end

end
