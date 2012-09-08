module GDash
  module Helper
    def dashboards_path
      "/"
    end

    def dashboard_path dashboard, options = nil
      if options
        options = options.map do |k, v|
          "#{k}=#{Rack::Utils.escape(v)}"
        end
        options = options.join "&"
        options = "?#{options}"
      end

      "/#{dashboard.name}#{options}"
    end

    def build_sidebar current = nil
      html = Builder::XmlMarkup.new

    end
  end
end