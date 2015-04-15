class ApplicationSweeper < ActionController::Caching::Sweeper

  observe Category, Color, Company, Page, Part, Product, Sale, Size, Testimonial

  USERS = ['WHOLESALE', 'ADMIN', 'USER_SIGNED_IN', 'USER_NOT_SIGNED_IN']

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
    return if @controller.nil?
    return unless @controller.respond_to? :expire_action

    ['index', 'store'].each do |action|
      USERS.each do |user|
        expire_action controller: 'homes', action: action, user_type: user
      end
    end

    ['cart', 'checkout'].each do |action|
      USERS.each do |user|
        expire_action controller: 'sales', action: action, user_type: user
      end
    end

    Product.all.each do |product|
      ['show', 'order', 'show'].each do |action|
        USERS.each do |user|
          expire_action controller: 'products', action: action, :id => product.id, user_type: user
        end
      end

      USERS.each do |user|
        expire_action controller: 'products', action: 'show', :id => product.id, user_type: user, format: 'json'
      end
    end

    Page.all.each do |page|
      USERS.each do |user|
        expire_action controller: 'pages', action: 'show', :id => page.id, user_type: user
      end
    end
  end

end
