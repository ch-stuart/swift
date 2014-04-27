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
            # FIXME appears this is not working. :(
            expire_action :controller => 'products', :action => 'order', :id => product.id, :user_type => 'WS', :format => 'json'
            expire_action :controller => 'products', :action => 'order', :id => product.id, :user_type => 'STANDARD', :format => 'json'
        end
        Page.all.each do |page|
            expire_action :controller => 'pages', :action => 'show', :id => page.id, :user_type => 'WS'
            expire_action :controller => 'pages', :action => 'show', :id => page.id, :user_type => 'STANDARD'
        end

        expire_action :controller => 'sales', :action => 'cart', :user_type => 'WS'
        expire_action :controller => 'sales', :action => 'cart', :user_type => 'STANDARD'
        expire_action :controller => 'sales', :action => 'checkout', :user_type => 'WS'
        expire_action :controller => 'sales', :action => 'checkout', :user_type => 'STANDARD'

        # TODO figure out how to expire cache for success action
        # Sale.all.each do |sale|
        #     expire_action :controller => 'sales', :action => 'success', :guid => sale.guid, :user_type => 'STANDARD'
        #     expire_action :controller => 'sales', :action => 'success', :guid => sale.guid, :user_type => 'WS'
        # end

        expire_fragment 'footer'
        expire_fragment 'global_nav'
        expire_fragment 'meta_description'
        expire_fragment 'company_description'
    end

end
