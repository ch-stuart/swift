class ApplicationSweeper < ActionController::Caching::Sweeper

    observe Color, Company, Page, Product, Size, Testimonial, Category

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
        expire_action :controller => 'homes', :action => 'index', :user_type => 'WS'
        expire_action :controller => 'homes', :action => 'index', :user_type => 'STANDARD'
        expire_action :controller => 'homes', :action => 'store', :user_type => 'WS'
        expire_action :controller => 'homes', :action => 'store', :user_type => 'STANDARD'

        Product.all.each do |product|
            expire_action :controller => 'products', :action => 'show', :id => product.id, :user_type => 'WS'
            expire_action :controller => 'products', :action => 'show', :id => product.id, :user_type => 'STANDARD'
            expire_action :controller => 'products', :action => 'order', :id => product.id, :user_type => 'WS'
            expire_action :controller => 'products', :action => 'order', :id => product.id, :user_type => 'STANDARD'
        end
        Page.all.each do |page|
            expire_action :controller => 'pages', :action => 'show', :id => page.id, :user_type => 'WS'
            expire_action :controller => 'pages', :action => 'show', :id => page.id, :user_type => 'STANDARD'
        end
    end

end
