class TestimonialSweeper < ActionController::Caching::Sweeper

    observe Testimonial

    def after_create(testimonial)
        expire_cache_for(testimonial)
    end

    def after_update(testimonial)
        expire_cache_for(testimonial)
    end

    def after_destroy(testimonial)
        expire_cache_for(testimonial)
    end

    private

    def expire_cache_for(testimonial)
        expire_page(:controller => 'testimonials', :action => 'index')
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