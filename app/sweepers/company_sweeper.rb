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