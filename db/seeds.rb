# encoding: UTF-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Company.create(
    :title => "Swift Industries",
    :email => "info@builtbyswift.com",
    :phone => "(206) 325.0054",
    :address => "1422 20th AVE Seattle, WA 98122",
    :description => "Swift Industries designs and handmakes custom bicycle panniers and accessories. Customers choose their bag and pannier colors and Swift Industries sews them to order. Swift Industries offers handcrafted bicycle panniers, porteur bags, bicycle saddle bags, and randonneuring bags."
)
Page.create(
    :title => "Our Story",
    :body => "todo",
    :path => "our_story",
    :video_html => '<iframe title="YouTube video player" width="460" height="374" src="http://www.youtube.com/embed/nmSfXqeHdbU" frameborder="0" allowfullscreen></iframe>',
    :status => "Public",
    :featured => "Featured"
)

Color.create( :title => "Black", :hex => "#000" )
Color.create( :title => "White", :hex => "#fff" )
Color.create( :title => "Yellow", :hex => "#f8e51b" )
Color.create( :title => "Neon Green", :hex => "#78f43e" )
Color.create( :title => "Teal", :hex => "#298e6a" )
Color.create( :title => "Royal Blue", :hex => "#2312a5" )
Color.create( :title => "Gray", :hex => "#cac9cf" )
Color.create( :title => "Brown", :hex => "#473029" )
Color.create( :title => "Burgundy", :hex => "#771830" )
Color.create( :title => "Purple", :hex => "#52206a" )
Color.create( :title => "Red", :hex => "#aa0909" )
Color.create( :title => "Burnt Orange", :hex => "#c7390a" )
Color.create( :title => "Hunter Orange", :hex => "#ff4100" )
Color.create( :title => "Field Tan Waxed Canvas", :hex => "#7e6211" )
Color.create( :title => "Olive", :hex => "#3e3b19" )
Color.create( :title => "Hot Pink", :hex => "#f0248b" )
Color.create( :title => "Ranger Tan Heavy Waxed Canvas", :hex => "#785c0d" )
Color.create( :title => "Charcoal", :hex => "#31313a" )
Color.create( :title => "Navy", :hex => "#272447" )
Color.create( :title => "Turquoise", :hex => "#0ac2b6" )
Color.create( :title => "Blue", :hex => "#1c31a6" )

Product.create(
    :kind                   => "Product",
    :status                 => "Public",
    :title                  => "Roll Top Panniers",
    :short_title            => "Roll Top",
    :price                  => "200.00",
    :humane_price           => "$200 a set",
    :specs                  => 'measurements: (15"h+12"roll) 25h"X13"wX6"d features: vinyl interior lining, external zip pockets, carrying handles, rear pockets, rear reflective strips, hook and cord mounting system',
    :description            => "The Swift Industries' Roll Top Pannier is a unique design inspired by our urban cycling communities. We've been riding year-round with the Roll Top model in the rainy Northwest, and between its roll and the adjustable flap we've found its capacity and waterproofing perfect for our urban endeavors and long-distance bicycle touring.",
    :flickr_tag             => "rtpslide",
    :flickr_photo           => "5477126433",
    :flickr_illustration    => "5486539852"
)
Product.create(
    :kind                   => "Product",
    :status                 => "Public",
    :title                  => "Short Stack Panniers",
    :short_title            => "Short Stack",
    :price                  => "230.00",
    :humane_price           => "$230 a set",
    :specs                  => 'measurements: 15"hX13"wX6"d plus a 9" telescoping neck. features: vinyl interior lining, external zip pocket, carrying handle, rear pocket, rear reflective strip, hook and cord mounting system, 9" telescoping neck with double cinch cords, zip lid pocket',
    :description            => "In 2007, and before the inception of Swift Industries, a bicycle tour in the Olympic Peninsula inspired Martina and Goods to design a set of bicycle panniers. Drawing from wilderness gear designs and previous bicycle tour experience, the two designed the Short Stack Pannier. Good's functional goal was a high volume bag with plenty of external pockets for tools, snacks, and maps. Martina's aesthetic vision was to create panniers that deviated from the technical look that most pannier companies had to offer. The foundation of Swift Industries rests on the Short Stack Pannier model.",
    :flickr_tag             => "ssslide",
    :flickr_photo           => "5481199492",
    :flickr_illustration    => "5486540020"
)
Product.create(
    :kind                   => "Product",
    :status                 => "Public",
    :title                  => "Mini Roll Top Panniers",
    :short_title            => "Mini Roll Top",
    :price                  => "180.00",
    :humane_price           => "$180 a set",
    :specs                  => 'measurements: (10"h+12" roll) 22h"X10"wX6"d features: vinyl interior lining, external zip pockets,  carrying handles, rear reflective strips, hook and cord mounting system',
    :description            => "Riding to work or to school year-round? You need a pannier that keeps your belongings dry and that is easy to carry off of your bicycle. If you're taking a ride across town you'll find the Mini Roll Top Bicycle Panniers the perfect size for your layers, snacks, and books. Heading down the Pacific Coast in September? Mount the Mini Roll Top Panniers to a front touring rack to complete your traveling set-up. We suggest combining the Mini Roll Top Panniers with the Short Stack model for extended bicycle tours.",
    :flickr_tag             => "mrtpslide",
    :flickr_photo           => "5477117583",
    :flickr_illustration    => ""
)
Product.create(
    :kind                   => "Product",
    :status                 => "Public",
    :title                  => "Mini Short Stack Panniers",
    :short_title            => "Mini Short Stack",
    :price                  => "200.00",
    :humane_price           => "$200 a set",
    :specs                  => 'measurements: 13h"X10w"tX6"d features: vinyl interior lining, external zip pocket, handle, rear reflective strip, hook and cord mounting system, 9" telescoping neck with double cinch cords, zip lid pocket',
    :description            => "Living on the road with one's bicycle as your home inspires us here at Swift Industries to no end. When you are your engine, and the world is at your fingertips you deserve the best gear to outfit your adventures. The Mini Short Stack Pannier is designed to mount to the front rack on your bicycle to help steady your ride when you're out for the long-haul. We found the external pockets vital on our longer excursions, and depended often on the waterproof body to keep our clothing dry. We also recommend the Mini Short Stack Pannier to the commuter cyclist and over-night adventurer.",
    :flickr_tag             => "mssslide",
    :flickr_photo           => "5477118943",
    :flickr_illustration    => "5486540020"
)
Product.create(
    :kind                   => "Product",
    :status                 => "Public",
    :title                  => "Ozette Rando Bag",
    :short_title            => "Ozette",
    :price                  => "999.99",
    :humane_price           => "$999.99",
    :specs                  => 'Specs: (Large) Measurements: 11"w x 9"d x 9" tall Features: Vinyl lined, lid opens from cyclist out, two 2.5" pockets facing rider, front pocket, 7.5"x11" clear map case on lid, flush side pockets, 2" velcro strips on bottom of the bag, webbing insert for rando rack’s anterior lip, and 1" dee rings on either side of the bag. Customer needs to source and install the decaleur. (Small) Measurements: 10"w x 8"d x 7" tall Features: Vinyl lined, lid opens from front back, 3.5" pocket on either side, front pocket, 6"x10" clear map case on lid, 2" velcro strips on bottom of the bag, webbing insert for rando rack’s anterior lip, and 1" dee rings on either side of the bag. Customer needs to source and install the decaleur. The Ozette Randoneurring Bag is inspired by the timeless front box design, and touts Swift Industries’ signature in the details. Our bag is completely vinyl-lined because we know that rain shouldn’t stop you. Keep charts and your cue sheet visible in the top map-case, and pack food and rain gear directly within arm’s reach. Discovered a coffee shop or brewery along the way? Easily slip the Ozette from the decaleur and rack and bring it inside. When you’re panning an Sub-24 hour overnight (S240), go the extra mile with a matching http://swiftindustries.wordpress.com/choose-your-colors/saddle-touring-bag/ Trunk Saddle Bag.',
    :description            => "The Ozette Randoneurring Bag is inspired by the timeless front box design, and touts Swift Industries’ signature in the details. Our bag is completely vinyl-lined because we know that rain shouldn’t stop you. Keep charts and your cue sheet visible in the top map-case, and pack food and rain gear directly within arm’s reach. Discovered a coffee shop or brewery along the way? Easily slip the Ozette from the decaleur and rack and bring it inside. When you’re panning an Sub-24 hour overnight (S240), go the extra mile with a matching Trunk Saddle Bag.",
    :flickr_tag             => "orbslide",
    :flickr_photo           => "5477718908",
    :flickr_illustration    => "5486539562"
)
Product.create(
    :kind                   => "Product",
    :status                 => "Public",
    :title                  => "Pelican Porteur Bag",
    :short_title            => "Pelican Porteur Bag",
    :price                  => "150.00",
    :humane_price           => "$150.00",
    :specs                  => 'measurements: 21h"X11w"X11d" features: vinyl interior, front zip pocket, external zip pocket, carrying handle, reflective strip, light mount',
    :description            => "Fit to carry your heaviest loads or deliver food piping hot, the Pelican Porteur Bag mounts onto your porteur rack with simple quick release buckles to hold your cargo in place. Roll down your excess baggage and pull the flap snug to brave blustery weather. You don’t need to open your bag to fish out your mini u-lock, slip it into the external holster for easy locking. We’ve  put a reflective strip on the front of the flap and a light mount so you’re visible. Off for an overnight solo adventure? Combine the Pelican Porteur Bag with the Trunk Saddle Touring Bag for a classic set-up.",
    :flickr_tag             => "ppbslide",
    :flickr_photo           => "5477120865",
    :flickr_illustration    => "5486539732"
)
Product.create(
    :kind                   => "Product",
    :status                 => "Public",
    :title                  => "Trunk Saddle Touring Bag",
    :short_title            => "Saddle Bag",
    :price                  => "999.99",
    :humane_price           => "$999.99",
    :specs                  => '(Large) Measurements: Body 12"wX8"hX6.5"d with a tapered side panel that measures 6" at the top and 8" at the bottom and external pockets (diameter of 1 lt H20 bottle). Features: Vinyl interior, leather straps, external side pockets, internal telescoping extension prevents your belongings from falling out. (Medium) Measurements: Body 10"wX6"hX"6"d with a tapered side panel that measures 6" at the top and 7" at the bottom and external pockets. Features: Vinyl interior, leather straps, external side pockets (fit: tube, multi-tool, patch kit), internal telescoping extension prevents your belongings from falling out.',
    :description            => "The Trunk Saddle Bag is inspired by the classic touring saddle bag, but here at Swift Industries you can build your bags from a range of 1000D Cordura colors to Fairfield Waxed Canvas. Two straps attach the Saddle Bag to the metal tabs on your saddle (as found on Brooks saddles and the like). The main compartment accommodates the belongings you may want on a long day on the saddle: snacks, rain gear, hand pump, coffee mug, book, day planner, and tall cans of your favorite malted beverage--to name a few.",
    :flickr_tag             => "tsbslide",
    :flickr_photo           => "5477128341",
    :flickr_illustration    => "5487842218"
)
Product.create(
    :kind                   => "Accessory",
    :status                 => "Public",
    :title                  => "Tweed & Canvas Little Dear",
    :short_title            => "Tweed Little Dear",
    :price                  => "999.99",
    :humane_price           => "$75.00 Tweed Flap",
    :specs                  => 'Measurements: 10" across X 10" diameter Features: Recycled tweed interior or flap (colors will vary), heavy weight waxed canvas, black stitching, black trim, light mount, three leather mounting straps',
    :description            => "The Little Dear Saddle Bag attaches to the metal tabs on your Brooks Saddle (and the like). Leather straps and a wooden dowel keep the bag in place and allow you to carry your personal goods as you take to the streets by bicycle. Stow your mini u-lock, a light jacket, wallet and snacks. A second flap snaps in place beneath the exterior cover to keep your belongings in place.",
    :flickr_tag             => "tweedslide",
    :flickr_photo           => "5477715404",
    :flickr_illustration    => "5487246937"
)
Product.create(
    :kind                   => "Accessory",
    :status                 => "Public",
    :title                  => "Integrated U-Lock Fanny Pack",
    :short_title            => "Fanny Pack",
    :price                  => "35.00",
    :humane_price           => "$35.00",
    :specs                  => "",
    :description            => "Here at Swift Industries we take minimizing our waste seriously. Our fanny pack is constructed from fabric scraps from pannier purchases. It's as simple as one single small compartment for your wallet and keys, and as brilliant as a wearable mini u-lock holster. This fanny pack is one-of-a-kind. While we make our fanny packs in batches, we don't make any two alike!",
    :flickr_tag             => "fpslide",
    :flickr_photo           => "5477714932",
    :flickr_illustration    => "5487842006"
)
Product.create(
    :kind                   => "Accessory",
    :status                 => "Public",
    :title                  => "Little Dear Saddle Bag",
    :short_title            => "Little Dear",
    :price                  => "999.99",
    :humane_price           => "$65.00/Canvas",
    :specs                  => 'Measurements: 10" across X 10" diameter Features: Heavy weight waxed canvas, black stitching, black trim, a light mount, snaps',
    :description            => "The Little Dear Saddle Bag attaches to the metal tabs on your Brooks Saddle (and the like). Leather straps and a wooden dowel keep the bag in place and allow you to carry your personal goods as you take to the streets by bicycle. Stow your mini u-lock, a light jacket, wallet and snacks. A second flap snaps in place beneath the exterior cover to keep your belongings in place.",
    :flickr_tag             => "ldsbslide",
    :flickr_photo           => "5477715194",
    :flickr_illustration    => "5487246937"
)
Product.create(
    :kind                   => "Accessory",
    :status                 => "Public",
    :title                  => "Mini Mechanic Tool Pouch",
    :short_title            => "Mini Mechanic",
    :price                  => "35.00",
    :humane_price           => "$35.00",
    :specs                  => "",
    :description            => "Keep all of your road-side survival tools in one place with this simple, well-built, and enduring pouch.",
    :flickr_tag             => "mmtpslide",
    :flickr_photo           => "5477715624",
    :flickr_illustration    => "5486539428"
)
