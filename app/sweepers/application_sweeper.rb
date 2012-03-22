class ApplicationSweeper < ActionController::Caching::Sweeper

    observe Color, Company, Page, Product, Size, Testimonial

    def after_create record
        expire_cache
    end

    def after_update record
        expire_cache
    end

    def after_destroy record
        expire_cache
    end

    def expire_cache
        expire_action :controller => 'homes', :action => 'index'
        expire_action :controller => 'homes', :action => 'accessories'

        Product.all.each do |product|
            expire_action :controller => 'products', :action => 'show', :id => product.id
            expire_action :controller => 'products', :action => 'order', :id => product.id
        end
        Page.all.each do |page|
            expire_action :controller => 'pages', :action => 'show', :id => page.id
        end
    end

end
