class HomesController < ApplicationController

    require "open-uri"

    before_filter :authenticate, :except => [ :index, :store ]
    caches_action :index, :store

    def index
        @pages = Page.find_all_by_status("Public")
        @featured_pages = Page.where(:featured => "Featured").reverse
        @products = Product.where(:status => "Public", :kind => "Product")
        @categories = Category.all
        @accessories = Product.where(:status => "Public", :kind => "Accessory")
        @company = Company.first

        @blog = get_latest_blog_post

        @featured_product = Product.where(:featured_on_homepage => true).first

        if @featured_product.blank?
            @featured_product = Product.first
        end

        if @featured_product.flickr_set.present?
            @photos = Home.get_photos_by_set @featured_product.flickr_set
        else
            @photos = Home.get_photos_by_tag @featured_product.flickr_tag
        end
    end

    def store
        @categories = Category.all
        @products = Product.where(:status => "Public", :kind => "Product")
        @accessories = Product.where(:status => "Public", :kind => "Accessory")
        @stock = Product.where(:status => "Public", :kind => "Stock")
        @company = Company.first
    end

    protected

    def get_latest_blog_post
        @blog = {}

        xml = open("http://cycleswift.wordpress.com/feed/")
        doc = Nokogiri::XML(xml)

        @blog["title"] = doc.at_css("rss channel item title").text
        @blog["link"] = doc.at_css("rss channel item link").text
        @blog["description"] = doc.at_css("rss channel item description").text
        img = doc.css("media|content")[1]
        @blog["img"] = img["url"].gsub("http:", "")

        @blog
    end
end
