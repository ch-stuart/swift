module SalesHelper

    def cents_to_dollars num
        num.to_f / 100
    end

    def last_name sale
        return "n/a" if sale.contact.nil?

        if sale.contact.include? " "
            sale.contact.split(" ").last
        else
            sale.contact
        end
    end

end
