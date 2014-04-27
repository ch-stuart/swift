task :add_shipping_attrs => :environment do
  shipping_attrs = YAML.load_file(File.join(Rails.root, "lib", "shipping_attrs.yml"))

  shipping_attrs.each do |attrs|
    puts "==== #{attrs['name']}"

    product = Product.find attrs["id"]
    product.update_attributes({
      width: attrs['width'],
      height: attrs['height'],
      length: attrs['depth'],
      weight: attrs['weight']
    })

    product.save!
  end
end
