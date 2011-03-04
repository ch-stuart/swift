class CompanySweeper < ActionController::Caching::Sweeper

    observe Company

    def after_create(company)
        expire_cache_for(company)
    end

    def after_update(company)
        expire_cache_for(company)
    end

    def after_destroy(company)
        expire_cache_for(company)
    end

    private

    def expire_cache_for(company)
        expire_page(:controller => 'companies', :action => 'index')
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