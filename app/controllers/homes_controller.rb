class HomesController < ApplicationController

    require "open-uri"

    before_filter :verify_is_admin, except: [ :index, :store ]

    caches_action :index, :store, :cache_path => Proc.new { |c| {
        'user_type' => get_user_type
      }
    }

    def index
      @blog = get_latest_blog_post

      @featured_product = Product.where(featured_on_homepage: true, status: "Public").first

      if @featured_product.blank?
        @featured_product = Product.first
      end

      if @featured_product.flickr_set.present?
        @photos = Home.get_photos_by_set @featured_product.flickr_set
      end
    end

    def store

    end

    protected

    def get_latest_blog_post
        @blog = nil

        begin
          @blog = {}
          xml = open("https://cycleswift.wordpress.com/feed/")

          return @blog unless xml.status[0] == "200"

          doc = Nokogiri::XML(xml)

          @blog["title"] = doc.at_css("rss channel item title").text
          @blog["link"] = doc.at_css("rss channel item link").text
          @blog["description"] = doc.at_css("rss channel item description").text.gsub("http:", "")

          img = doc.css("media|content")[1]["url"]
          img = img.gsub("http:", "")
          img = img.gsub("https:", "")
          img = img.gsub(/\?w=\d+$/, "")

          @blog["img"] = img unless img.blank?
        rescue Exception => e
          @blog = nil
          logger.error e
        end

        @blog
    end
end
