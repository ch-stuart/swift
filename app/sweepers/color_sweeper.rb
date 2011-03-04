class ColorSweeper < ActionController::Caching::Sweeper

    observe Color

    def after_create(color)
        expire_cache_for(color)
    end

    def after_update(color)
        expire_cache_for(color)
    end

    def after_destroy(color)
        expire_cache_for(color)
    end

    private

    def expire_cache_for(color)
        expire_page(:controller => 'colors', :action => 'index')
        expire_page(:controller => 'products', :action => 'index')
        expire_page(:controller => 'homes', :action => 'index')
        expire_page(:controller => 'homes', :action => 'accessories')
        expire_page(:controller => 'hubs', :action => 'index')

        Product.all.each do |product|
            expire_page(product_path(product))
            expire_page(order_product_path(product))
        end
        Page.all.each do |page|
            expire_page(page_path(page))
        end
    end

end