class HomesController < ApplicationController

    require 'open-uri'

    before_filter :authenticate, :except => [ :index, :store ]
    # caches_page :index, :store
    caches_action :index, :store

    def index
        @pages = Page.find_all_by_status('Public')
        @featured_page = Page.find_by_featured('Featured')
        @products = Product.where(:status => 'Public', :kind => 'Product')
        @categories = Category.all
        @accessories = Product.where(:status => 'Public', :kind => 'Accessory')
        @company = Company.first

        @blog = get_latest_blog_post

        @photos = Home.get_photos
    end

    def store
        @products = Product.where(:status => 'Public', :kind => 'Product')
        @accessories = Product.where(:status => 'Public', :kind => 'Accessory')
        @stock = Product.where(:status => 'Public', :kind => 'Stock')
        @company = Company.first
    end

    private

    def get_latest_blog_post
        @blog = {}

        xml = open("http://cycleswift.wordpress.com/feed/")
        doc = Nokogiri::XML(xml)

        @blog['title'] = doc.at_css("rss channel item title").text
        @blog['link'] = doc.at_css("rss channel item link").text
        @blog['description'] = doc.at_css("rss channel item description").text
        img = doc.css("media|content")[1]
        @blog['img'] = img['url']

        @blog
    end
end
