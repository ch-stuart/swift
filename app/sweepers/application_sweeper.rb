class ApplicationSweeper < ActionController::Caching::Sweeper

    observe Category, Color, Company, Page, Part, Product, Size, Testimonial

    def after_create record
        Rails.logger.info "ApplicationSweeper#after_create"
        expire_cache
    end

    def after_update record
        Rails.logger.info "ApplicationSweeper#after_update"
        expire_cache
    end

    def after_destroy record
        Rails.logger.info "ApplicationSweeper#after_destroy"
        expire_cache
    end

    def expire_cache
        expire_action :controller => 'homes', :action => 'index', :user_type => 'WHOLESALE'
        expire_action :controller => 'homes', :action => 'index', :user_type => 'ADMIN'
        expire_action :controller => 'homes', :action => 'index', :user_type => 'USER_SIGNED_IN'
        expire_action :controller => 'homes', :action => 'index', :user_type => 'USER_NOT_SIGNED_IN'
        expire_action :controller => 'homes', :action => 'store', :user_type => 'WHOLESALE'
        expire_action :controller => 'homes', :action => 'store', :user_type => 'ADMIN'
        expire_action :controller => 'homes', :action => 'store', :user_type => 'USER_SIGNED_IN'
        expire_action :controller => 'homes', :action => 'store', :user_type => 'USER_NOT_SIGNED_IN'

        Product.all.each do |product|
            expire_action :controller => 'products', :action => 'show', :id => product.id, :user_type => 'WHOLESALE'
            expire_action :controller => 'products', :action => 'show', :id => product.id, :user_type => 'ADMIN'
            expire_action :controller => 'products', :action => 'show', :id => product.id, :user_type => 'USER_SIGNED_IN'
            expire_action :controller => 'products', :action => 'show', :id => product.id, :user_type => 'USER_NOT_SIGNED_IN'
            expire_action :controller => 'products', :action => 'order', :id => product.id, :user_type => 'WHOLESALE'
            expire_action :controller => 'products', :action => 'order', :id => product.id, :user_type => 'ADMIN'
            expire_action :controller => 'products', :action => 'order', :id => product.id, :user_type => 'USER_SIGNED_IN'
            expire_action :controller => 'products', :action => 'order', :id => product.id, :user_type => 'USER_NOT_SIGNED_IN'
            expire_action :controller => 'products', :action => 'show', :id => product.id, :user_type => 'WHOLESALE', :format => 'json'
            expire_action :controller => 'products', :action => 'show', :id => product.id, :user_type => 'ADMIN', :format => 'json'
            expire_action :controller => 'products', :action => 'show', :id => product.id, :user_type => 'USER_SIGNED_IN', :format => 'json'
            expire_action :controller => 'products', :action => 'show', :id => product.id, :user_type => 'USER_NOT_SIGNED_IN', :format => 'json'
        end

        Page.all.each do |page|
            expire_action :controller => 'pages', :action => 'show', :id => page.id, :user_type => 'WHOLESALE'
            expire_action :controller => 'pages', :action => 'show', :id => page.id, :user_type => 'ADMIN'
            expire_action :controller => 'pages', :action => 'show', :id => page.id, :user_type => 'USER_SIGNED_IN'
            expire_action :controller => 'pages', :action => 'show', :id => page.id, :user_type => 'USER_NOT_SIGNED_IN'
        end

        expire_action :controller => 'sales', :action => 'cart', :user_type => 'WHOLESALE'
        expire_action :controller => 'sales', :action => 'cart', :user_type => 'ADMIN'
        expire_action :controller => 'sales', :action => 'cart', :user_type => 'USER_SIGNED_IN'
        expire_action :controller => 'sales', :action => 'cart', :user_type => 'USER_NOT_SIGNED_IN'
        expire_action :controller => 'sales', :action => 'checkout', :user_type => 'WHOLESALE'
        expire_action :controller => 'sales', :action => 'checkout', :user_type => 'ADMIN'
        expire_action :controller => 'sales', :action => 'checkout', :user_type => 'USER_SIGNED_IN'
        expire_action :controller => 'sales', :action => 'checkout', :user_type => 'USER_NOT_SIGNED_IN'

        # TODO figure out how to expire cache for success action
        # Sale.all.each do |sale|
        #     expire_action :controller => 'sales', :action => 'success', :guid => sale.guid, :user_type => 'ADMIN'
        #     expire_action :controller => 'sales', :action => 'success', :guid => sale.guid, :user_type => 'WHOLESALE'
        #     expire_action :controller => 'sales', :action => 'success', :guid => sale.guid, :user_type => 'USER_SIGNED_IN'
        #     expire_action :controller => 'sales', :action => 'success', :guid => sale.guid, :user_type => 'USER_NOT_SIGNED_IN'
        # end
    end

end
