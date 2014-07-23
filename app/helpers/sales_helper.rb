module SalesHelper

    def last_name sale
        return "n/a" if sale.contact.nil?

        if sale.contact.include? " "
            sale.contact.split(" ").last
        else
            sale.contact
        end
    end

end
