SwiftSite::Application.config.middleware.insert_before(Rack::Lock, Rack::Rewrite) do

    if Rails.env == "production"

        # Redirect to https if scheme is http
        # r301 %r{.*}, "https://www.builtbyswift.com$&", :scheme => "http"

        # Redirect to www if server name is builtbyswift.com
        r301 %r{.*}, "https://www.builtbyswift.com$&", :if => Proc.new { |rack_env|
            rack_env["SERVER_NAME"] != "www.builtbyswift.com"
        }

    end

end
