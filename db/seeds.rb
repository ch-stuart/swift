# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Product.create(
    :title => "Roll Top Panniers",
    :short_title => "Roll Top",
    :description => "The Swift Industries' Roll Top Pannier is a unique design inspired by our urban cycling communities. We've been riding year-round with the Roll Top model in the rainy Northwest, and between its roll and the adjustable flap we've found its capacity and waterproofing perfect for our urban endeavors and long-distance bicycle touring.",
    :flickr_tag => "roll_top_panniers",
    :flickr_photo => "5424890613",
    :specs => "$200 a set. measurements: (15'h+12'roll) 25h'X13'wX6'd",
    :status => "Public",
    :price => "200.00",
    :kind => "Product"
)
Product.create(
    :title => "Mini Roll Top Panniers",
    :short_title => "Mini Roll Top",
    :description => "Riding to work or to school year-round? You need a pannier that keeps your belongings dry and that is easy to carry off of your bicycle. If you're taking a ride across town you'll find the Mini Roll Top Bicycle Panniers the perfect size for your layers, snacks, and books. Heading down the Pacific Coast in September? Mount the Mini Roll Top Panniers to a front touring rack to complete your traveling set-up. We suggest combining the Mini Roll Top Panniers with the Short Stack model for extended bicycle tours.",
    :flickr_tag => "mini_roll_top_panniers",
    :flickr_photo => "5424890613",
    :specs => "measurements: (10'h+12' roll) 22h'X10'wX6'd",
    :status => "Public",
    :price => "180.00",
    :kind => "Product"
)
Product.create(
    :title => "Short Stack Panniers",
    :short_title => "Short Stack",
    :description => "In 2007, and before the inception of Swift Industries, a bicycle tour in the Olympic Peninsula inspired Martina and Goods to design a set of bicycle panniers. Drawing from wilderness gear designs and previous bicycle tour experience, the two designed the Short Stack Pannier. Good's functional goal was a high volume bag with plenty of external pockets for tools, snacks, and maps. Martina's aesthetic vision was to create panniers that deviated from the technical look that most pannier companies had to offer. The foundation of Swift Industries rests on the Short Stack Pannier model.",
    :flickr_tag => "short_stack_panniers",
    :flickr_photo => "5424890613",
    :specs => "measurements: 15'hX13'wX6'd plus a 9' telescoping neck",
    :status => "Public",
    :price => "230.00",
    :kind => "Product"
)
Product.create(
    :title => "Mini Short Stack Panniers",
    :short_title => "Mini Short Stack",
    :description => "Living on the road with one's bicycle as your home inspires us here at Swift Industries to no end. When you are your engine, and the world is at your fingertips you deserve the best gear to outfit your adventures. The Mini Short Stack Pannier is designed to mount to the front rack on your bicycle to help steady your ride when you're out for the long-haul. We found the external pockets vital on our longer excursions, and depended often on the waterproof body to keep our clothing dry. We also recommend the Mini Short Stack Pannier to the commuter cyclist and over-night adventurer.",
    :flickr_tag => "mini_short_stack_panniers",
    :flickr_photo => "5424890613",
    :specs => "measurements: 13h'X10w″tX6'd",
    :status => "Public",
    :price => "200.00",
    :kind => "Product"
)
Product.create(
    :title => "Trunk Saddle Touring Bag",
    :short_title => "Trunk Saddle Touring Bag",
    :description => "The Trunk Saddle Bag is inspired by the classic touring saddle bag, but here at Swift Industries you can build your bags from a range of 1000D Cordura colors to Fairfield Waxed Canvas. Two straps attach the Saddle Bag to the metal tabs on your saddle (as found on Brooks saddles and the like). The main compartment accommodates the belongings you may want on a long day on the saddle: snacks, rain gear, hand pump, coffee mug, book, day planner, and tall cans of your favorite malted beverage--to name a few.",
    :flickr_tag => "trunk_saddle_touring_bag",
    :flickr_photo => "5424890613",
    :specs => "Measurements: Body 14'wX8h″ with a tapered side panel that measures 6″ at the top and 8″ at the bottom and external pockets.",
    :status => "Public",
    :price => "110.00",
    :kind => "Product"
)
Product.create(
    :title => "Pelican Porteur Bag",
    :short_title => "Pelican Porteur",
    :description => "Fit to carry your heaviest loads or deliver food piping hot, the Pelican Porteur Bag mounts onto your porteur rack with simple quick release buckles to hold your cargo in place. Roll down your excess baggage and pull the flap snug to brave blustery weather. You don’t need to open your bag to fish out your mini u-lock, slip it into the external holster for easy locking. We’ve  put a reflective strip on the front of the flap and a light mount so you’re visible. Off for an overnight solo adventure? Combine the Pelican Porteur Bag with the Trunk Saddle Touring Bag for a classic set-up.",
    :flickr_tag => "pelican_porteur_bag",
    :flickr_photo => "5424890613",
    :status => "Public",
    :price => "150.00",
    :kind => "Product"
)
Product.create(
    :title => "Ozette Rando Bag",
    :short_title => "Ozette Rando",
    :description => "",
    :flickr_tag => "ozette_rando_bag",
    :flickr_photo => "5424890613",
    :status => "Public",
    :price => "210.00",
    :kind => "Product"
)
Product.create(
    :title => "Mini Mechanic Tool Pouch",
    :short_title => "Tool Pouch",
    :description => "Keep all of your road-side survival tools in one place with this simple, well-built, and enduring pouch.",
    :flickr_tag => "mini_mechanic_tool_pouch",
    :flickr_photo => "5424890613",
    :status => "Public",
    :price => "35.00",
    :kind => "Accessory"
)
Product.create(
    :title => "Integrated U-Lock Fanny Pack",
    :short_title => "Fanny Pack",
    :description => "Here at Swift Industries we take minimizing our waste seriously. Our fanny pack is constructed from fabric scraps from pannier purchases. It's as simple as one single small compartment for your wallet and keys, and as brilliant as a wearable mini u-lock holster. This fanny pack is one-of-a-kind. While we make our fanny packs in batches, we don't make any two alike!",
    :flickr_tag => "integrated_ulock_fanny_pack",
    :flickr_photo => "5424890613",
    :status => "Public",
    :price => "35.00",
    :kind => "Accessory"
)
Product.create(
    :title => "Little Dear Saddle Bag",
    :short_title => "Saddle Bag",
    :description => "The Little Dear Saddle Bag attaches to the metal tabs on your Brooks Saddle (and the like). Leather straps and a wooden dowel keep the bag in place and allow you to carry your personal goods as you take to the streets by bicycle. Stow your mini u-lock, a light jacket, wallet and snacks. A second flap snaps in place beneath the exterior cover to keep your belongings in place.",
    :flickr_tag => "little_dear_saddle_bag",
    :flickr_photo => "5424890613",
    :status => "Public",
    :price => "65.00",
    :kind => "Accessory"
)
Product.create(
    :title => "Tweed & Canvas Little Dear",
    :short_title => "Canvas Saddle Bag",
    :description => "The Little Dear Saddle Bag attaches to the metal tabs on your Brooks Saddle (and the like). Leather straps and a wooden dowel keep the bag in place and allow you to carry your personal goods as you take to the streets by bicycle. Stow your mini u-lock, a light jacket, wallet and snacks. A second flap snaps in place beneath the exterior cover to keep your belongings in place.",
    :flickr_tag => "tweed_canvas_little_dear",
    :flickr_photo => "5424890613",
    :status => "Public",
    :price => "75.00",
    :kind => "Accessory"
)

Color.create(
    :title => "Hot Pink",
    :hex => "#de41a4"
)

Color.create(
    :title => "Black",
    :hex => "#000"
)

Color.create(
    :title => "White",
    :hex => "#fff"
)

Color.create(
    :title => "Gray",
    :hex => "#aaa"
)
Company.create(
    :title => "Swift Industries",
    :email => "swiftindustry@yahoo.com",
    :phone => "(206) 325.0054",
    :address => "1422 20th AVE Seattle, WA 98122"
)
Page.create(
    :title => "Our Story",
    :body => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    :path => "our_story",
    :video_html => '<iframe title="YouTube video player" width="480" height="390" src="http://www.youtube.com/embed/nmSfXqeHdbU" frameborder="0" allowfullscreen></iframe>',
    :status => "Public",
    :featured => "Featured"
)
