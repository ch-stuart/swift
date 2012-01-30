class PageSweeper < ActionController::Caching::Sweeper

    observe Page

    def after_create(page)
        expire_cache_for(page)
    end

    def after_update(page)
        expire_cache_for(page)
    end

    def after_destroy(page)
        expire_cache_for(page)
    end

    private

    def expire_cache_for(page)
        # expire_page(:controller => 'homes', :action => 'index')
        # expire_page(:controller => 'homes', :action => 'accessories')

        expire_action :controller => 'homes', :action => 'index'
        expire_action :controller => 'homes', :action => 'accessories'

        Product.all.each do |product|
            # expire_page(product_path(product))
            # expire_page(order_product_path(product))
            expire_action :controller => 'products', :action => 'show', :id => product.id
            expire_action :controller => 'products', :action => 'order', :id => product.id
        end
        Page.all.each do |page|
            # expire_page(page_path(page))
            expire_action :controller => 'pages', :action => 'show', :id => page.id
        end
    end

end