class ProductSweeper < ActionController::Caching::Sweeper

    observe Product

    def after_create(product)
        expire_cache_for(product)
    end

    def after_update(product)
        expire_cache_for(product)
    end

    def after_destroy(product)
        expire_cache_for(product)
    end

    private

    def expire_cache_for(product)
        expire_page(:controller => 'homes', :action => 'index')
        expire_page(:controller => 'homes', :action => 'accessories')

        Product.all.each do |product|
            expire_page(product_path(product))
            expire_page(order_product_path(product))
        end
        Page.all.each do |page|
            expire_page(page_path(page))
        end
    end

end