class SizeSweeper < ActionController::Caching::Sweeper

    observe Size

    def after_create(size)
        expire_cache_for(size)
    end

    def after_update(size)
        expire_cache_for(size)
    end

    def after_destroy(size)
        expire_cache_for(size)
    end

    private

    def expire_cache_for(size)
        expire_page(:controller => 'sizes', :action => 'index')
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